//// from: Lat: 47.15334, Long: 27.587713
//// to: Lat: 47.164654, Long: 27.582195

//using Newtonsoft.Json.Linq;

//var fromLat = 47.15334;
//var fromLong = 27.587713;

//var toLat = 47.164654;
//var toLong = 27.582195;

//var travelMode = "driving"; //"walking";

//HttpClient client = new();

//string base_Url = "https://maps.googleapis.com/maps/api/distancematrix/json?";
//string mode = "mode=" + travelMode;
//string units = "units=metric";
//string apiKey = "key=AIzaSyDlvGPPAHeaSX9zsC3FiMHCi3Ix-YFvHVk";

// async Task<int> GetTime()
//{
//    var URL = $"{base_Url}origins={fromLat},{fromLong}&destinations={toLat},{toLong}&{mode}&{units}&{apiKey}";
//    var responseContent = await (await client.GetAsync(URL)).Content.ReadAsStringAsync();
//    //return (int)JObject.Parse(responseContent)["rows"][0]["elements"][0]["duration"]["value"];
//}

//var result = GetTime().Result;
Console.WriteLine("Hello World!");