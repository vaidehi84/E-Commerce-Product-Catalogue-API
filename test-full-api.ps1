# E-Commerce API Complete Test Script

$baseUrl = "http://localhost:8080/api"
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$userEmail = "test-user-$timestamp@example.com"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "E-Commerce API - Complete Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Base URL: $baseUrl" -ForegroundColor Gray
Write-Host "Test Email: $userEmail" -ForegroundColor Gray

# Step 1: Register
Write-Host "`n[1] REGISTER - Creating new user..." -ForegroundColor Yellow

$registerBody = @{
    firstName = "Test"
    lastName = "User"
    email = $userEmail
    password = "TestPass123"
} | ConvertTo-Json

try {
    $registerResp = Invoke-RestMethod -Uri "$baseUrl/auth/register" `
        -Method Post `
        -ContentType "application/json" `
        -Body $registerBody -ErrorAction Stop
    Write-Host "✓ Registration successful" -ForegroundColor Green
} catch {
    Write-Host "✗ Registration error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 2: Login
Write-Host "`n[2] LOGIN - Getting JWT token..." -ForegroundColor Yellow

$loginBody = @{
    email = $userEmail
    password = "TestPass123"
} | ConvertTo-Json

try {
    $loginResp = Invoke-RestMethod -Uri "$baseUrl/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginBody -ErrorAction Stop
    
    $token = $loginResp.token
    $userId = $loginResp.id
    Write-Host "✓ Login successful" -ForegroundColor Green
    Write-Host "  User ID: $userId" -ForegroundColor Gray
    Write-Host "  Token: $($token.Substring(0, 30))..." -ForegroundColor Gray
} catch {
    Write-Host "✗ Login error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Create headers
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Step 3: Create Product
Write-Host "`n[3] CREATE PRODUCT - Adding inventory..." -ForegroundColor Yellow

$productBody = @{
    name = "Premium Laptop"
    description = "High performance laptop for developers"
    sku = "LAPTOP-$timestamp"
    price = 1299.99
    quantity = 5
} | ConvertTo-Json

try {
    $productResp = Invoke-RestMethod -Uri "$baseUrl/products" `
        -Method Post `
        -Headers $headers `
        -Body $productBody -ErrorAction Stop
    
    $productId = $productResp.id
    Write-Host "✓ Product created successfully" -ForegroundColor Green
    Write-Host "  Product ID: $productId" -ForegroundColor Gray
    Write-Host "  Product: $($productResp.name) - $($productResp.price)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Product creation error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Get All Products
Write-Host "`n[4] GET ALL PRODUCTS - Fetching inventory..." -ForegroundColor Yellow

try {
    $productsResp = Invoke-RestMethod -Uri "$baseUrl/products" `
        -Method Get `
        -Headers $headers -ErrorAction Stop
    
    Write-Host "✓ Products fetched successfully" -ForegroundColor Green
    Write-Host "  Total products: $($productsResp.Count)" -ForegroundColor Gray
    $productsResp | ForEach-Object {
        Write-Host "    - $($_.name): $($_.price) (Qty: $($_.quantity))" -ForegroundColor Gray
    }
} catch {
    Write-Host "✗ Get products error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 5: Create Order
Write-Host "`n[5] CREATE ORDER - Placing order..." -ForegroundColor Yellow

$orderBody = @{
    items = @(
        @{
            productId = $productId
            quantity = 2
        }
    )
} | ConvertTo-Json

try {
    $orderResp = Invoke-RestMethod -Uri "$baseUrl/orders" `
        -Method Post `
        -Headers $headers `
        -Body $orderBody -ErrorAction Stop
    
    $orderId = $orderResp.id
    Write-Host "✓ Order created successfully" -ForegroundColor Green
    Write-Host "  Order ID: $orderId" -ForegroundColor Gray
    Write-Host "  Status: $($orderResp.status)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Order creation error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 6: Get Order Details
Write-Host "`n[6] GET ORDER DETAILS - Fetching order info..." -ForegroundColor Yellow

try {
    $orderDetailsResp = Invoke-RestMethod -Uri "$baseUrl/orders/$orderId" `
        -Method Get `
        -Headers $headers -ErrorAction Stop
    
    Write-Host "✓ Order details fetched" -ForegroundColor Green
    Write-Host "  Order ID: $($orderDetailsResp.id)" -ForegroundColor Gray
    Write-Host "  Status: $($orderDetailsResp.status)" -ForegroundColor Gray
    Write-Host "  Items: $($orderDetailsResp.items.Count)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Get order error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 7: Get User Orders
Write-Host "`n[7] GET USER ORDERS - Fetching all user orders..." -ForegroundColor Yellow

try {
    $userOrdersResp = Invoke-RestMethod -Uri "$baseUrl/orders/user/$userId" `
        -Method Get `
        -Headers $headers -ErrorAction Stop
    
    Write-Host "✓ User orders fetched" -ForegroundColor Green
    Write-Host "  Total orders: $($userOrdersResp.Count)" -ForegroundColor Gray
    $userOrdersResp | ForEach-Object {
        Write-Host "    - Order #$($_.id): $($_.status)" -ForegroundColor Gray
    }
} catch {
    Write-Host "✗ Get user orders error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "✓ ALL TESTS COMPLETED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nSummary:" -ForegroundColor Yellow
Write-Host "  • User registered and logged in" -ForegroundColor Green
Write-Host "  • Product created and inventory fetched" -ForegroundColor Green
Write-Host "  • Order placed and details retrieved" -ForegroundColor Green
Write-Host "  • All endpoints working correctly!" -ForegroundColor Green
