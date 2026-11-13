# Recipe Explorer

Recipe Explorer is a Flutter application created for a Mobile Application Development course assignment. The app connects to the public **DummyJSON Recipes REST API** and displays culinary recipes in a clean, responsive interface with full CRUD operations, pagination, search, and offline local caching.

## Features

- **Browse Recipes**: Responsive list layout displaying images, names, cuisine types, ratings, and cook times.
- **Recipe Detail Screen**: Detailed view showing ingredients list, step-by-step instructions, prep/cook times, and servings.
- **Search**: Keyword search via `/recipes/search`.
- **CRUD Operations**: Create, edit, and delete recipes synced with API responses and local cache.
- **Pagination**: Infinite loading via `limit` and `skip`.
- **Local Cache**: Offline access supported using `Hive`.
- **Pull-to-Refresh & Error Handling**: Robust state management via `Provider`.

## API Information

| Item | Value |
| :--- | :--- |
| **API** | DummyJSON Recipes |
| **Base URL** | `https://dummyjson.com` |
| **Authentication** | None required |
| **Documentation** | `https://dummyjson.com/docs/recipes` |
| **Response Format** | JSON |

## API Endpoints Used

| HTTP Method | Endpoint | Purpose |
| :--- | :--- | :--- |
| `GET` | `/recipes?limit=10&skip=0` | Fetch paginated recipes |
| `GET` | `/recipes/search?q={query}` | Search recipes by name |
| `POST` | `/recipes/add` | Simulate creating a recipe |
| `PUT` | `/recipes/{id}` | Simulate updating a recipe |
| `DELETE` | `/recipes/{id}` | Simulate deleting a recipe |

## Packages Used

- `dio` — HTTP client
- `provider` — State management
- `hive` & `hive_flutter` — Local offline cache
- `cached_network_image` — Image loading

## How to Run

1. Clone or extract repository:
   ```bash
   cd recipe-explorer-flutter
   ```
2. Generate platform folders if needed:
   ```bash
   flutter create .
   ```
3. Get packages:
   ```bash
   flutter pub get
   ```
4. Run app:
   ```bash
   flutter run
   ```
