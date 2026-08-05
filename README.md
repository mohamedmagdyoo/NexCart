<img width="1376" height="768" alt="screen copy" src="https://github.com/user-attachments/assets/1ad04057-ab4e-41f5-a625-0b993c175256" />
<img width="1376" height="768" alt="screen copy 2" src="https://github.com/user-attachments/assets/81a47a1e-fbeb-4aed-a5c4-cfbb63585354" />
<img width="1376" height="768" alt="screen" src="https://github.com/user-attachments/assets/0cde9529-8b46-4a0c-bd8d-7b3f34edcaf2" />
<img width="1376" height="768" alt="screen copy 3" src="https://github.com/user-attachments/assets/9a2f2462-ab40-4698-82b0-fbcf0e4d409d" />

# NexCart 

> A native iOS e-commerce app built on Shopify, featuring AI-powered outfit visualization.

Built as part of the ITI/JETS Mobile Lab program.

---

## 📱 About the App

NexCart is a fully-featured iOS shopping app connected to a live Shopify store. It's designed to feel like a real production retail app rather than a demo storefront — covering the full journey from browsing to checkout, plus an AI-driven feature that lets users visualize outfits before buying.

### Core Features

- **Product Catalog** — Browse the Obsidian Maison de Mode catalog, synced live from Shopify.
- **Authentication** — Email/password and social login via Firebase Auth, with automatic Shopify customer account linkage on signup.
- **Favorites** — Save products locally (CoreData) and in the cloud (Firestore) with dual-write sync, so favorites persist across devices and reinstalls.
- **Address Management** — Add, edit, and manage shipping addresses with a local-first save flow and automatic rollback if a remote save fails.
- **Coupons & Discounts** — Validate discount codes live against Shopify's discount engine.
- **Checkout** — Address selection with Apple Pay and Cash on Delivery support.
- **Onboarding** — Guided first-run experience for new users.
- **✨ AI Outfit Generator** — Select multiple products from the catalog and generate a single composite visualization showing how they look together as an outfit, powered by AI image generation.

---

## 🛠 Tech Stack

### Language & UI
- **Swift** / **SwiftUI**
- Async/await used throughout for all networking and asynchronous work

### Architecture
- **Clean Architecture** — strict separation across Domain → Data → Presentation layers
- **MVVM** on top of the presentation layer, with a `ScreenState` enum (`idle` / `loading` / `success` / `error`) driving UI state per screen
- **50+ use cases** — one use case per file, one protocol per use case, a single `execute()` method each (no generic `UseCase<Input, Output>` abstraction)
- Protocol-first design at every layer, enabling swappable implementations and testability

### Dependency Injection
- **Swinject** — centralized `DIContainer`, with registrations grouped and labeled by feature

### Persistence
- **CoreData** — local/offline storage using a DAO-owns-container pattern
- **Firebase Firestore** — cloud sync, with dual-write patterns (e.g. Favorites) to keep local and remote in sync

### Backend & Auth
- **Firebase Auth** — identity and session management
- **Shopify Admin REST API** — catalog, customers, orders
- **Shopify GraphQL Admin API** — discount code lookups (`codeDiscountNodeByCode`), since REST has no equivalent single-call endpoint

### AI Outfit Generation
- `ImageDownloadService` — fetches product images from Shopify URLs
- `ImageCompositionService` — composites selected product images into a single strip using `UIGraphicsImageRenderer`
- Composited image is base64-encoded and sent to an AI image-generation provider behind a protocol-first abstraction, allowing providers to be swapped independently of the rest of the pipeline
- Providers integrated: **HuggingFace (FLUX.1-Kontext-dev via fal-ai)**, **Google Gemini (2.5 Flash Image)**, and **Pollinations.ai**

> *Note: fill in here if there are additional AI models/modes beyond the above — update this section before publishing.*

### Tooling
- **Xcode 14**
- **Swift Package Manager** for dependencies
- Postman collection for Shopify API testing

---

## 📐 Architecture Overview

```
Presentation (SwiftUI Views + ViewModels)
        ↓
   Domain (Entities, Use Case Protocols, Use Cases)
        ↑
     Data (Repositories, DAOs, API Services, Providers)
```

- Each feature is wired through Swinject with clearly labeled registrations (e.g. `//For Favorites`, `//For Outfit Generator`)
- Domain layer has zero knowledge of Data or Presentation — only protocols
- Data layer implements domain protocols and owns all CoreData/Firestore/Shopify integration details

---

## 🚀 Getting Started

### Prerequisites
- Xcode 14+
- CocoaPods / Swift Package Manager
- Firebase project with Auth + Firestore enabled
- Access to a Shopify development store with Admin API credentials

### Setup
1. Clone the repository
2. Open `NexCart.xcodeproj` in Xcode
3. Add your `GoogleService-Info.plist` (Firebase config)
4. Configure Shopify store credentials (store domain + Admin API access token)
5. Build and run

---

## 👥 Team

Built by a team as part of the ITI/JETS Mobile Lab course project.

