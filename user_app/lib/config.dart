final url = 'http://192.168.1.107:3000/';
final register = url + "register";
final login = url + "login";
final updateCart = url + "cart/add";
final clearCart = url + "cart/clear";
final getCart = url + "cart/"; // Add this line for fetching the cart
final getmenu = url + "menu/"; // Append sellerUID when making the request
final getitem = url + "item/"; // Add this line if it's not already there
final addAddress = url + "address/add"; // Add this line for adding an address
final getAddresses = url + "address/"; // Add this line for fetching addresses
final getAddressDetails = url +
    "address/details/"; // Add this line for fetching address details by addressId
final placeOrder = url + "order/place"; // Add this line for placing an order
final getOrders =
    url + "order/recent/"; // Add this line for fetching recent orders
final getOrderDetails = url +
    "order/details/"; // Add this line for fetching order details by orderId
final getDeliveredOrders =
    url + "order/delivered/"; // Add this line for fetching delivered orders
final findSellerByName =
    url + "seller/find"; // Add this line for finding sellers by name
final addMonyToWallet =
    url + "wallet/add"; // Add this line for adding money to wallet
final useWalltForPayment =
    url + "wallet/use"; // Add this line for using wallet for payment
final createStripeCheckoutSesion = url +
    "create-checkout-session"; // Add this line for creating Stripe checkout session

const String API_BASE = 'http://192.168.1.107:3000/';
const String getSellers = API_BASE + 'seller/getsellers';
const String findSeller = API_BASE + 'seller/find';
