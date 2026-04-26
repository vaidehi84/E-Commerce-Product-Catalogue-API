# E-Commerce API

A complete REST API for an e-commerce platform built with **Spring Boot 3.2**, **Spring Security**, **JWT Authentication**, and **PostgreSQL**.

## Features

✅ User Authentication & Authorization (JWT)
✅ Role-Based Access Control (ADMIN/USER)
✅ Product Management (CRUD)
✅ Order Management
✅ Order Items Tracking
✅ Stock Management
✅ Request Validation
✅ Global Exception Handling
✅ PostgreSQL Database
✅ Spring Data JPA

## Tech Stack

- **Java 17**
- **Spring Boot 3.2.4**
- **Spring Security 6**
- **Spring Data JPA**
- **PostgreSQL**
- **JWT (JJWT)**
- **Lombok**
- **Maven**

## Prerequisites

- Java 17 or higher
- PostgreSQL 12 or higher
- Maven 3.6 or higher
- Git

## Setup Instructions

### 1. Database Setup

```sql
CREATE DATABASE ecommerce_db;
```

### 2. Clone the Repository

```bash
git clone <repository-url>
cd ecommerce-api
```

### 3. Configure Application Properties

Edit `src/main/resources/application.properties`:

```properties
spring.datasource.username=postgres
spring.datasource.password=YOUR_PASSWORD
jwt.secret=YOUR_SECRET_KEY
jwt.expiration=86400000
```

### 4. Build the Project

```bash
mvn clean install
```

### 5. Run the Application

```bash
mvn spring-boot:run
```

The application will start on `http://localhost:8080`

## API Endpoints

### Authentication Endpoints
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Product Endpoints
- `GET /api/products` - Get all products (Public)
- `GET /api/products/{id}` - Get product by ID (Public)
- `POST /api/products` - Create product (Admin only)
- `PUT /api/products/{id}` - Update product (Admin only)
- `DELETE /api/products/{id}` - Delete product (Admin only)

### Order Endpoints
- `POST /api/orders` - Place new order (Authenticated)
- `GET /api/orders` - Get user's orders (Authenticated)
- `GET /api/orders/{id}` - Get order details (Authenticated)
- `PUT /api/orders/{id}/status` - Update order status (Admin only)

## Sample Request/Response

### Register User
```bash
POST http://localhost:8080/api/auth/register
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

### Login
```bash
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

Response includes JWT token to be used in subsequent requests as:
```
Authorization: Bearer {token}
```

### Create Product (Admin)
```bash
POST http://localhost:8080/api/products
Content-Type: application/json
Authorization: Bearer {admin-token}

{
  "name": "Laptop",
  "description": "High-performance laptop",
  "sku": "LAPTOP-001",
  "price": 999.99,
  "quantity": 10
}
```

### Place Order
```bash
POST http://localhost:8080/api/orders
Content-Type: application/json
Authorization: Bearer {user-token}

{
  "items": [
    {
      "productId": 1,
      "quantity": 2
    }
  ]
}
```

## Project Structure

```
ecommerce-api/
├── src/main/java/com/ecommerce/
│   ├── config/              # Configuration classes
│   ├── controller/          # REST Controllers
│   ├── dto/                 # Data Transfer Objects
│   ├── entity/              # JPA Entities
│   ├── exception/           # Exception handling
│   ├── repository/          # Data Access Layer
│   ├── security/            # Security components
│   ├── service/             # Business logic
│   └── EcommerceApiApplication.java
├── src/main/resources/
│   └── application.properties
├── pom.xml
└── README.md
```

## Deployment

### Deploy to Railway

1. Install Railway CLI
2. Connect GitHub repository
3. Set environment variables:
   - `SPRING_DATASOURCE_URL`
   - `SPRING_DATASOURCE_USERNAME`
   - `SPRING_DATASOURCE_PASSWORD`
   - `JWT_SECRET`

4. Deploy:
```bash
railway up
```

### Deploy to Render

1. Connect GitHub repository
2. Create PostgreSQL database
3. Set environment variables
4. Deploy with `mvn clean install`

## Default Roles

- **ROLE_USER** - Regular user (can browse products, place orders)
- **ROLE_ADMIN** - Administrator (can manage products, update orders)

## Security

- Passwords are hashed using BCrypt
- JWT tokens expire after 24 hours
- All sensitive endpoints require authentication
- CSRF protection enabled
- Role-based access control implemented

## Testing

Use the provided `ecommerce-api.http` file with REST Client extension in VS Code to test all endpoints.

## Troubleshooting

### Connection to Database Failed
- Ensure PostgreSQL is running
- Verify connection details in application.properties
- Check database exists: `CREATE DATABASE ecommerce_db;`

### Port Already in Use
- Change port in application.properties: `server.port=8081`

### JWT Token Invalid
- Verify token is included in Authorization header
- Check token hasn't expired
- Ensure JWT secret matches

## License

MIT License

## Support

For issues and questions, please create an issue in the repository.
