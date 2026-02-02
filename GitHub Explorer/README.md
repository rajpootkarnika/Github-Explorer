
# GitHub Explorer (SwiftUI)

A clean, modern SwiftUI app that searches GitHub repositories using the public GitHub REST API.
Built to demonstrate MVVM, async/await networking, pagination, debounced search, and production-ready UI states.

## Features
- Debounced repository search (prevents calling API on every keystroke)
- Sorting (Stars / Updated)
- Infinite scroll pagination
- Pull-to-refresh
- Repository detail screen
- User profile screen
- Solid UI states: loading, empty, error, retry
- GitHub rate-limit friendly error messages (basic handling)

## Tech Stack
- SwiftUI + NavigationStack
- MVVM
- async/await
- URLSession
- Decodable models (ISO8601 date parsing)
- GitHub Actions CI (build + test)

## Screens
- Search → Results List → Repo Details → User Profile

> Add screenshots/gif here after you record a short demo.

## Project Structure (high level)
- Core: NetworkClient, Endpoint, errors
- Data: GitHub endpoints + repository implementation
- Domain: Models
- Presentation: Screens, ViewModels, reusable UI components

## API
Uses GitHub public REST API:
- Search repos: `GET https://api.github.com/search/repositories`
- Repo detail: `GET https://api.github.com/repos/{owner}/{repo}`
- User profile: `GET https://api.github.com/users/{username}`

No API key required (but unauthenticated requests are rate limited by GitHub).

## How to Run
1. Open the project in Xcode
2. Select an iOS Simulator (iOS 17+ recommended)
3. Build & Run

## Future Improvements
- Saved/bookmarked repos with SwiftData
- Offline cache for last search results
- Image caching for avatars
- Unit tests for ViewModels (network mocking)
- Better rate-limit UI (countdown until reset)

## 📄 License
MIT
