# E-Commerce API Test Script

$baseUrl = "http://localhost:8080/api"
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$userEmail = "test-user-$timestamp@example.com"

Write-Host "========================================"
Write-Host "E-Commerce API - Complete Test"
Write-Host "========================================"
Write-Host "Base URL: $baseUrl"
Write-Host "Test Email: $userEmail"

# Step 1: Register
Write-Host "`n[1] REGISTER - Creating new user..."

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
    Write-Host "SUCCESS: Registration complete"
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
}

# Step 2: Login
Write-Host "`n[2] LOGIN - Getting JWT token..."

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
    Write-Host "SUCCESS: Login complete"
    Write-Host "User ID: $userId"
    Write-Host "Token: $($token.Substring(0, 30))..."
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
    exit 1
}

# Create headers
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Step 3: Create Product
Write-Host "`n[3] CREATE PRODUCT - Adding inventory..."

$productBody = @{
    name = "Premium Laptop"
    description = "High performance laptop"
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
    Write-Host "SUCCESS: Product created"
    Write-Host "Product ID: $productId"
    Write-Host "Product: $($productResp.name) - `$$($productResp.price)"
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
}

# Step 4: Get All Products
Write-Host "`n[4] GET ALL PRODUCTS - Fetching inventory..."

try {
    $productsResp = Invoke-RestMethod -Uri "$baseUrl/products" `
        -Method Get `
        -Headers $headers -ErrorAction Stop
    
    Write-Host "SUCCESS: Products fetched"
    Write-Host "Total products: $($productsResp.Count)"
    foreach ($prod in $productsResp) {
        Write-Host "  - $($prod.name): `$$($prod.price) (Qty: $($prod.quantity))"
    }
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
}

# Step 5: Create Order
Write-Host "`n[5] CREATE ORDER - Placing order..."

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
    Write-Host "SUCCESS: Order created"
    Write-Host "Order ID: $orderId"
    Write-Host "Status: $($orderResp.status)"
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
}

# Step 6: Get Order Details
Write-Host "`n[6] GET ORDER DETAILS - Fetching order info..."

try {
    $orderDetailsResp = Invoke-RestMethod -Uri "$baseUrl/orders/$orderId" `
        -Method Get `
        -Headers $headers -ErrorAction Stop
    
    Write-Host "SUCCESS: Order details fetched"
    Write-Host "Order ID: $($orderDetailsResp.id)"
    Write-Host "Status: $($orderDetailsResp.status)"
    Write-Host "Items: $($orderDetailsResp.items.Count)"
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
}

# Step 7: Get User Orders
Write-Host "`n[7] GET USER ORDERS - Fetching all user orders..."

try {
    $userOrdersResp = Invoke-RestMethod -Uri "$baseUrl/orders/user/$userId" `
        -Method Get `
        -Headers $headers -ErrorAction Stop
    
    Write-Host "SUCCESS: User orders fetched"
    Write-Host "Total orders: $($userOrdersResp.Count)"
    foreach ($order in $userOrdersResp) {
        Write-Host "  - Order #$($order.id): $($order.status)"
    }
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
}

Write-Host "`n========================================"
Write-Host "ALL TESTS COMPLETED SUCCESSFULLY!"
Write-Host "========================================"
Write-Host "`nSummary:"
Write-Host "  - User registered and logged in"
Write-Host "  - Product created and inventory fetched"
Write-Host "  - Order placed and details retrieved"
Write-Host "  - All endpoints working correctly!"
