// --- CONFIGURATION ---
const STORE_NAME = "your-store-name"; // Replace with your store name
const ADMIN_API_KEY = "shpat_xxxxxxxxxxxxxxxxxxxx"; // Replace with your Admin API key
const API_VERSION = "2024-04"; // Use a recent version like 2024-04

const SHOPIFY_ENDPOINT = `https://${STORE_NAME}.myshopify.com/admin/api/${API_VERSION}/graphql.json`;
const SHOPIFY_HEADERS = {
  "X-Shopify-Access-Token": ADMIN_API_KEY,
  "Content-Type": "application/json",
};

// --- GRAPHQL QUERIES ---

// 1. Fetch just the Product IDs for the current page
const GET_PRODUCTS_QUERY = `
  query GetProducts($first: Int!, $after: String) {
    products(first: $first, after: $after) {
      edges {
        cursor
        node {
          id
        }
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
  }
`;

// 2. Fetch the specific content and digests for a single ID
const GET_DIGESTS_QUERY = `
  query getProductDigests($resourceId: ID!) {
    translatableResource(resourceId: $resourceId) {
      translatableContent {
        key
        value 
        digest
      }
    }
  }
`;

// 3. Register the translation
const REGISTER_TRANSLATION_MUTATION = `
  mutation registerProductTranslations($resourceId: ID!, $translations: [TranslationInput!]!) {
    translationsRegister(resourceId: $resourceId, translations: $translations) {
      userErrors { message field }
    }
  }
`;

// --- HELPER: FREE TRANSLATION ENGINE ---
async function translateTextToArabic(text) {
  if (!text || text.trim() === "") return text;

  try {
    const encodedText = encodeURIComponent(text);
    const response = await fetch(`https://api.mymemory.translated.net/get?q=${encodedText}&langpair=en|ar`);
    const data = await response.json();
    return data.responseData.translatedText || text;
  } catch (error) {
    console.error(`   ⚠️ Translation API failed for text snippet. Falling back to original.`);
    return text; 
  }
}

// --- CORE TRANSLATION PROCESSOR ---
async function processProductTranslation(productId) {
  // Step A: Get the digests and original text for this specific product
  const digestResponse = await fetch(SHOPIFY_ENDPOINT, {
    method: "POST",
    headers: SHOPIFY_HEADERS,
    body: JSON.stringify({
      query: GET_DIGESTS_QUERY,
      variables: { resourceId: productId },
    }),
  });

  const digestJson = await digestResponse.json();
  const contentArray = digestJson.data?.translatableResource?.translatableContent;

  if (!contentArray || contentArray.length === 0) {
    console.log(`   ⏭️ Skipping ${productId}: No translatable content found.`);
    return;
  }

  const targetKeys = ["title", "body_html", "product_type"];
  const translationsInput = [];

  // Step B: Translate the data
  for (const item of contentArray) {
    if (targetKeys.includes(item.key)) {
      const arabicText = await translateTextToArabic(item.value);
      
      translationsInput.push({
        locale: "ar",
        key: item.key,
        value: arabicText,
        translatableContentDigest: item.digest
      });
    }
  }

  if (translationsInput.length === 0) return;

  // Step C: Save back to Shopify
  const registerResponse = await fetch(SHOPIFY_ENDPOINT, {
    method: "POST",
    headers: SHOPIFY_HEADERS,
    body: JSON.stringify({
      query: REGISTER_TRANSLATION_MUTATION,
      variables: { resourceId: productId, translations: translationsInput },
    }),
  });

  const registerJson = await registerResponse.json();
  const errors = registerJson.data?.translationsRegister?.userErrors;

  if (errors && errors.length > 0) {
    console.log(`   ❌ Failed to save translations for ${productId}`, errors);
  } else {
    console.log(`   ✅ Successfully translated product: ${productId}`);
  }
}

// --- MAIN RUNNER: PAGINATION LOOP ---
async function translateEntireCatalog() {
  console.log("🚀 Launching Full Catalog Auto-Translation Pipeline...");
  
  let hasNextPage = true;
  let cursor = null;
  let batchCount = 1;

  while (hasNextPage) {
    console.log(`\n📦 Processing Batch #${batchCount}...`);

    try {
      // Get a batch of 20 products
      const response = await fetch(SHOPIFY_ENDPOINT, {
        method: "POST",
        headers: SHOPIFY_HEADERS,
        body: JSON.stringify({
          query: GET_PRODUCTS_QUERY,
          variables: {
            first: 20, 
            after: cursor
          }
        }),
      });

      const json = await response.json();
      
      if (json.errors) {
        console.error("💥 Shopify API Error:", json.errors);
        break;
      }

      const productsConnection = json.data.products;
      if (!productsConnection) {
         console.error("💥 Could not fetch products, please verify your API token and endpoint.");
         break;
      }

      const productEdges = productsConnection.edges;

      // Process each ID in the batch
      for (const edge of productEdges) {
        await processProductTranslation(edge.node.id);
        
        // 1-second rest between products to avoid hitting API rate limits
        await new Promise(resolve => setTimeout(resolve, 1000)); 
      }

      // Prepare for the next loop
      hasNextPage = productsConnection.pageInfo.hasNextPage;
      cursor = productsConnection.pageInfo.endCursor;
      batchCount++;

    } catch (error) {
      console.error("💥 Critical execution error during batch:", error.message);
      break; 
    }
  }

  console.log("\n🎉 Finished! The entire catalog check/translation loop is complete.");
}

// --- RUN THE AUTOMATION ---
translateEntireCatalog();
