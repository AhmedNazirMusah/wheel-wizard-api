# Wheel Wizard API

A Ruby on Rails 7 API for managing car rentals and reservations, featuring JWT authentication and Swagger documentation.

## Tech Stack
- **Framework:** Ruby on Rails 7.0.4 (API Mode)
- **Ruby Version:** 3.1.3
- **Database:** PostgreSQL
- **Authentication:** Devise + `devise-jwt` with custom `JsonWebToken` decoding in `ApplicationController`.
- **Testing:** RSpec, FactoryBot, Faker, Shoulda-Matchers.
- **Documentation:** RSwag (Swagger) accessible at `/api-docs`.
- **Storage:** Active Storage for car images.

## Project Structure & Conventions

### API Versioning
- All API endpoints must be namespaced under `api/v1`.
- Controllers are located in `app/controllers/api/v1/`.
- Routes are defined in `config/routes.rb`.

### Authentication
- `ApplicationController` implements `authenticate_user_if_token_present` which sets `@current_user` based on the JWT `sub` claim.
- Custom JWT logic is located in `lib/json_web_token.rb`.
- Devise handles registration and sessions.

### Models & Associations
- **User:** Has many reservations and many cars through reservations.
- **Car:** Has one attached image (Active Storage), many reservations, and many users through reservations.
- **Reservation:** Belongs to a user and a car.
- **JwtBlacklist:** Used for token revocation.

### Coding Standards
- **JSON Responses:** Use explicit rendering in controllers. For models with Active Storage attachments, include the URL using `url_for` or similar.
- **Linting:** Rubocop is used for code quality. Run `bundle exec rubocop` before committing.
- **Tests:** RSpec is the mandatory testing framework. Place specs in `spec/` following the established directory structure.

## Core Mandates for Gemini CLI
1. **Testing:** Always include RSpec tests for new features or bug fixes. Ensure they follow the patterns in `spec/requests/api/v1/`.
2. **Swagger:** When adding or modifying API endpoints, update the RSwag specs or the `swagger/v1/swagger.yaml` file.
3. **Security:** Do not expose sensitive user data in API responses.
4. **Active Storage:** When dealing with Car images, ensure they are handled via Active Storage and URLs are correctly generated for the frontend.
5. **Namespacing:** Strictly adhere to the `Api::V1` namespace for all external-facing controllers.
