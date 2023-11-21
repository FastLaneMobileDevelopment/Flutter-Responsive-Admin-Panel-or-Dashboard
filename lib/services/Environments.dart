import 'dart:collection';


class Environments
{
  var urls = new HashMap();

  Environments() {
    urls['Development'] = "https://test.autic.app:6443";
    urls['Production_application'] =  "https://test.autic.app:6443"; // "http://192.168.1.47:3000"; //

   // urls['Production_application'] =  "http://192.168.1.41:3000"; // "http://192.168.1.163:3000"; //"http://192.168.1.43:3000";  // "http://51.91.111.55:6000";
  }

  String getHost (String env, String product) {
    if (env == null)
    {
      env = "Development";
    }

    if (env.isEmpty)
    {
      env = "Development";
    }

    return urls[env+"_"+product];
  }


  String get (String env)
  {
    if (env == null)
    {
      env = "Development";
    }

    if (env.isEmpty)
    {
      env = "Development";
    }

    return urls[env];
  }
}