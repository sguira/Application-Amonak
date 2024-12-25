

const String apiLink="https://amonak-api.vercel.app/api";

String? tokenValue;

Map<String,String> authHeader={
    'Content-type':'application/json', 
    'Authorization':"Bearer $tokenValue"
  };