

const String apiLink="https://amonak-api.vercel.app/api";
// const String apiLink="http://localhost:5000/api";
// const String apiLink="192.168.59.1:5000/api";
// const String apiLink="http:192.168.1.78:5000/api";
String? tokenValue;

Map<String,String> authHeader={
    'Content-type':'application/json', 
    'Authorization':"Bearer $tokenValue"
};