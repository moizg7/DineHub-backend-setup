final url = 'http://192.168.1.107:3000/';
final register = url + "seller/register";
final login = url + "seller/login";
final getmenu = url + "menu/"; // Append sellerUID when making the request
final createmenu = url + "menu/createMenu";
final getitem = url + "item/"; // Append sellerUID when making the request
final createitem = url + "item/createItem";
final deleteItem = url + "item/delete"; // Ensure this is correct
final delMenu = url + "menu/delete"; // Add this line
final getNewOrders =
    url + "order/new/"; // Add this line for fetching new orders
final getItemsByIds =
    url + "item/getItemsByIds"; // Add this line for fetching items by IDs
final getOrderDetails =
    url + "order/details/"; // Add this line for fetching order details
final getUserAddress =
    url + "address/details/"; // Add this line for fetching user address
final updateOrderStat =
    url + "order/updateStatus"; // Add this line for updating order status
final getTotalEarnings = url +
    "order/earnings/"; // Add this line for getting total earnings by seller
