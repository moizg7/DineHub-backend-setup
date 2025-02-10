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

const String API_BASE = 'http://192.168.1.107:3000/';
const String getSellers = API_BASE + 'seller/getsellers';
const String findSeller = API_BASE + 'seller/find';
