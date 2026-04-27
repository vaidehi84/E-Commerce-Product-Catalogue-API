# E-Commerce API Test Script

$baseUrl = "http://localhost:8080/api"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "E-Commerce API Testing" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Step 1: Register a new user
Write-Host "`n[1] Registering new user..." -ForegroundColor Yellow

$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$registerBody = @{
    firstName = "John"
    lastName = "Doe"
    email = "john-$timestamp@example.com"
    password = "password123"
} | ConvertTo-Json

try {
    $registerResponse = Invoke-RestMethod -Uri "$baseUrl/auth/register" `
        -Method Post `
        -ContentType "application/json" `
        -Body $registerBody
    Write-Host "✓ User registered successfully!" -ForegroundColor Green
    Write-Host "Response: $($registerResponse | ConvertTo-Json)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Registration failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 2: Login and get JWT token
Write-Host "`n[2] Logging in..." -ForegroundColor Yellow

$userEmail = "john-$timestamp@example.com"
$loginBody = @{
    email = $userEmail
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginBody
    
    $token = $loginResponse.token
    Write-Host "✓ Login successful!" -ForegroundColor Green
    Write-Host "Token: $token" -ForegroundColor Gray
} catch {
    Write-Host "✗ Login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Create headers with token
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Step 3: Get user ID
Write-Host "`n[3] Fetching user details..." -ForegroundColor Yellow

try {
    $userId = $loginResponse.id
    Write-Host "✓ User ID: $userId" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to get user ID: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Create a product
Write-Host "`n[4] Creating product..." -ForegroundColor Yellow

$productBody = @{
    name = "Laptop"
    description = "High-performance laptop"
    sku = "LAPTOP-001"
    price = 999.99
    quantity = 10
} | ConvertTo-Json

try {
    $productResponse = Invoke-RestMethod -Uri "$baseUrl/products" `
        -Method Post `
        -Headers $headers `
        -Body $productBody
    
    $productId = $productResponse.id
    Write-Host "✓ Product created successfully!" -ForegroundColor Green
    Write-Host "Product ID: $productId" -ForegroundColor Gray
    Write-Host "Response: $($productResponse | ConvertTo-Json)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Product creation failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 5: Get all products
Write-Host "`n[5] Fetching all products..." -ForegroundColor Yellow

try {
    $productsResponse = Invoke-RestMethod -Uri "$baseUrl/products" `
        -Method Get `
        -Headers $headers
    
    Write-Host "✓ Products fetched successfully!" -ForegroundColor Green
    Write-Host "Total products: $($productsResponse.Count)" -ForegroundColor Gray
    Write-Host "Products: $($productsResponse | ConvertTo-Json)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Failed to fetch products: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 6: Create an order
Write-Host "`n[6] Creating order..." -ForegroundColor Yellow

$orderBody = @{
    items = @(
        @{
            productId = $productId
            quantity = 2
        }
    )
} | ConvertTo-Json

try {
    $orderResponse = Invoke-RestMethod -Uri "$baseUrl/orders" `
        -Method Post `
        -Headers $headers `
        -Body $orderBody
    
    $orderId = $orderResponse.id
    Write-Host "✓ Order created successfully!" -ForegroundColor Green
    Write-Host "Order ID: $orderId" -ForegroundColor Gray
    Write-Host "Response: $($orderResponse | ConvertTo-Json)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Order creation failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 7: Get order details
Write-Host "`n[7] Fetching order details..." -ForegroundColor Yellow

try {
    $orderDetailsResponse = Invoke-RestMethod -Uri "$baseUrl/orders/$orderId" `
        -Method Get `
        -Headers $headers
    
    Write-Host "✓ Order details fetched successfully!" -ForegroundColor Green
    Write-Host "Response: $($orderDetailsResponse | ConvertTo-Json)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Failed to fetch order details: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 8: Get user orders
Write-Host "`n[8] Fetching user orders..." -ForegroundColor Yellow

try {
    $userOrdersResponse = Invoke-RestMethod -Uri "$baseUrl/orders/user/$userId" `
        -Method Get `
        -Headers $headers
    
    Write-Host "✓ User orders fetched successfully!" -ForegroundColor Green
    Write-Host "Total orders: $($userOrdersResponse.Count)" -ForegroundColor Gray
    Write-Host "Response: $($userOrdersResponse | ConvertTo-Json)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Failed to fetch user orders: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "All tests completed!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
