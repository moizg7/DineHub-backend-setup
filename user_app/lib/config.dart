final url = 'http://192.168.1.107:3000/';
final register = url + "register";
final login = url + "login";
final updateCart = url + "cart/add";
final clearCart = url + "cart/clear";
final getCart = url + "cart/"; // Add this line for fetching the cart
final getmenu = url + "menu/"; // Append sellerUID when making the request
final getitem = url + "item/"; // Add this line if it's not already there

const String API_BASE = 'http://192.168.1.107:3000/';
const String getSellers = API_BASE + 'seller/getsellers';
const String findSeller = API_BASE + 'seller/find';
