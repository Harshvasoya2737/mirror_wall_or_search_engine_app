import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_wall/provider/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:mirror_wall/provider/home_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/theme_provider.dart';

class MyWebPage extends StatefulWidget {
  const MyWebPage({super.key});

  @override
  State<MyWebPage> createState() => _MyWebPageState();
}

class _MyWebPageState extends State<MyWebPage> {
  InAppWebViewController? inAppWebViewController;
  PullToRefreshController? pullToRefreshController;
  TextEditingController searchController = TextEditingController();

  get index => null;

  @override
  void initState() {
    Provider.of<HomeProvider>(context, listen: false).onChangeLoad(true);
    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (Platform.isAndroid) {
          inAppWebViewController?.reload();
        } else {
          var webUri = await inAppWebViewController?.getUrl();
          inAppWebViewController?.loadUrl(urlRequest: URLRequest(url: webUri));
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Browser",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "All Bookmarks",
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Divider(),
                                  SizedBox(height: 15),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: homeProvider.bookmarks.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                              maxLines: 3,
                                              homeProvider.bookmarks[index]),
                                          onTap: () {
                                            inAppWebViewController?.loadUrl(
                                              urlRequest: URLRequest(
                                                url: WebUri(homeProvider
                                                    .bookmarks[index]),
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          trailing: IconButton(
                                            onPressed: () {
                                              homeProvider.removeBookmark(
                                                  homeProvider
                                                      .bookmarks[index]);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.close),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/book-marked-removebg-preview.png"),
                              backgroundColor: Colors.transparent),
                          SizedBox(width: 8),
                          Text("All Bookmarks")
                        ],
                      ),
                    ),
                    value: 'all_bookmarks',
                  ),
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Choose Search Engine'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      homeProvider.setSearchEngine(1);
                                      inAppWebViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                          url:
                                              WebUri(homeProvider.searchEngine),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/goggle-logo-removebg-preview.png"),
                                              backgroundColor:
                                                  Colors.transparent),
                                          Radio(
                                            value: 1,
                                            groupValue:
                                                homeProvider.searchEngineValue,
                                            onChanged: (value) {
                                              homeProvider.setSearchEngine(1);
                                              inAppWebViewController?.loadUrl(
                                                urlRequest: URLRequest(
                                                  url: WebUri(homeProvider
                                                      .searchEngine),
                                                ),
                                              );
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                homeProvider.setSearchEngine(1);
                                                inAppWebViewController?.loadUrl(
                                                  urlRequest: URLRequest(
                                                    url: WebUri(homeProvider
                                                        .searchEngine),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Google")),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      homeProvider.setSearchEngine(2);
                                      inAppWebViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                          url:
                                              WebUri(homeProvider.searchEngine),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/yahoo_logo-removebg-preview.png"),
                                              backgroundColor:
                                                  Colors.transparent),
                                          Radio(
                                            value: 2,
                                            groupValue:
                                                homeProvider.searchEngineValue,
                                            onChanged: (value) {
                                              homeProvider.setSearchEngine(2);
                                              inAppWebViewController?.loadUrl(
                                                urlRequest: URLRequest(
                                                  url: WebUri(homeProvider
                                                      .searchEngine),
                                                ),
                                              );
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                homeProvider.setSearchEngine(
                                                    2); // Set to Yahoo
                                                inAppWebViewController?.loadUrl(
                                                  urlRequest: URLRequest(
                                                    url: WebUri(homeProvider
                                                        .searchEngine),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Yahoo")),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      homeProvider.setSearchEngine(3);
                                      inAppWebViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                          url:
                                              WebUri(homeProvider.searchEngine),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/Bing_logo-removebg-preview.png"),
                                              backgroundColor:
                                                  Colors.transparent),
                                          Radio(
                                            value: 3,
                                            groupValue:
                                                homeProvider.searchEngineValue,
                                            onChanged: (value) {
                                              homeProvider.setSearchEngine(
                                                  3); // Set to Bing
                                              inAppWebViewController?.loadUrl(
                                                urlRequest: URLRequest(
                                                  url: WebUri(homeProvider
                                                      .searchEngine),
                                                ),
                                              );
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                homeProvider.setSearchEngine(3);
                                                inAppWebViewController?.loadUrl(
                                                  urlRequest: URLRequest(
                                                    url: WebUri(homeProvider
                                                        .searchEngine),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Bing"))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      homeProvider.setSearchEngine(4);
                                      inAppWebViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                          url:
                                              WebUri(homeProvider.searchEngine),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/duckduckgo_logo-removebg-preview.png"),
                                              backgroundColor:
                                                  Colors.transparent),
                                          Radio(
                                            value: 4,
                                            groupValue:
                                                homeProvider.searchEngineValue,
                                            onChanged: (value) {
                                              homeProvider.setSearchEngine(4);
                                              inAppWebViewController?.loadUrl(
                                                urlRequest: URLRequest(
                                                  url: WebUri(homeProvider
                                                      .searchEngine),
                                                ),
                                              );
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                homeProvider.setSearchEngine(4);
                                                inAppWebViewController?.loadUrl(
                                                  urlRequest: URLRequest(
                                                    url: WebUri(homeProvider
                                                        .searchEngine),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text("DuckDuckGo")),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/search-3png.png"),
                              backgroundColor: Colors.transparent),
                          SizedBox(width: 8),
                          Text("Choose Search Engine")
                        ],
                      ),
                    ),
                    value: 'choose_search_engine',
                  ),
                ];
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff243C98),
                      Colors.black,
                    ]),
              ),
              child: Column(
                children: [
                  Text(
                    'Hi, Welcome to Your Search Engine',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              tileColor: Color(0xff243C98),
              title: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Choose the Search Engine",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                homeProvider.setSearchEngine(1);
                                inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                    url: WebUri(homeProvider.searchEngine),
                                  ),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/images/goggle-logo-removebg-preview.png"),
                                          backgroundColor: Colors.transparent),
                                    ),
                                    Radio(
                                      value: 1,
                                      groupValue:
                                          homeProvider.searchEngineValue,
                                      onChanged: (value) {
                                        homeProvider.setSearchEngine(
                                            1); // Set to Google
                                        inAppWebViewController?.loadUrl(
                                          urlRequest: URLRequest(
                                            url: WebUri(
                                                homeProvider.searchEngine),
                                          ),
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          homeProvider.setSearchEngine(
                                              1); // Set to Google
                                          inAppWebViewController?.loadUrl(
                                            urlRequest: URLRequest(
                                              url: WebUri(
                                                  homeProvider.searchEngine),
                                            ),
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Google")),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () {
                                homeProvider.setSearchEngine(2); // Set to Yahoo
                                inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                    url: WebUri(homeProvider.searchEngine),
                                  ),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/images/yahoo_logo-removebg-preview.png"),
                                          backgroundColor: Colors.transparent),
                                    ),
                                    Radio(
                                      value: 2,
                                      groupValue:
                                          homeProvider.searchEngineValue,
                                      onChanged: (value) {
                                        homeProvider
                                            .setSearchEngine(2); // Set to Yahoo
                                        inAppWebViewController?.loadUrl(
                                          urlRequest: URLRequest(
                                            url: WebUri(
                                                homeProvider.searchEngine),
                                          ),
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          homeProvider.setSearchEngine(
                                              2); // Set to Yahoo
                                          inAppWebViewController?.loadUrl(
                                            urlRequest: URLRequest(
                                              url: WebUri(
                                                  homeProvider.searchEngine),
                                            ),
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Yahoo")),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () {
                                homeProvider.setSearchEngine(3); // Set to Bing
                                inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                    url: WebUri(homeProvider.searchEngine),
                                  ),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/Bing_logo-removebg-preview.png"),
                                      ),
                                    ),
                                    Radio(
                                      value: 3,
                                      groupValue:
                                          homeProvider.searchEngineValue,
                                      onChanged: (value) {
                                        homeProvider
                                            .setSearchEngine(3); // Set to Bing
                                        inAppWebViewController?.loadUrl(
                                          urlRequest: URLRequest(
                                            url: WebUri(
                                                homeProvider.searchEngine),
                                          ),
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          homeProvider.setSearchEngine(
                                              3); // Set to Bing
                                          inAppWebViewController?.loadUrl(
                                            urlRequest: URLRequest(
                                              url: WebUri(
                                                  homeProvider.searchEngine),
                                            ),
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Bing"))
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () {
                                homeProvider
                                    .setSearchEngine(4); // Set to DuckDuckGo
                                inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                    url: WebUri(homeProvider.searchEngine),
                                  ),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/duckduckgo_logo-removebg-preview.png"),
                                      ),
                                    ),
                                    Radio(
                                      value: 4,
                                      groupValue:
                                          homeProvider.searchEngineValue,
                                      onChanged: (value) {
                                        homeProvider.setSearchEngine(
                                            4); // Set to DuckDuckGo
                                        inAppWebViewController?.loadUrl(
                                          urlRequest: URLRequest(
                                            url: WebUri(
                                                homeProvider.searchEngine),
                                          ),
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          homeProvider.setSearchEngine(
                                              4); // Set to DuckDuckGo
                                          inAppWebViewController?.loadUrl(
                                            urlRequest: URLRequest(
                                              url: WebUri(
                                                  homeProvider.searchEngine),
                                            ),
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text("DuckDuckGo")),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Divider(),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xff243C98)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<ThemeProvider>(
                  builder:
                      (BuildContext context, themeProvider, Widget? child) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.ac_unit,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Theme :",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        DropdownButton(
                          dropdownColor: Colors.teal,
                          value: themeProvider.themeMode,
                          items: [
                            DropdownMenuItem(
                                child: Text(
                                  "System",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: 0),
                            DropdownMenuItem(
                                child: Text(
                                  "Light",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: 1),
                            DropdownMenuItem(
                                child: Text(
                                  "Dark",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: 2),
                          ],
                          onChanged: (newValue) {
                            themeProvider.changeTheme(newValue ?? 0);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: 407.5,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(16))),
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Exit",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Consumer<HomeProvider>(
            builder: (BuildContext context, HomeProvider value, Widget? child) {
              if (value.webProgress == 1) {
                return SizedBox();
              } else {
                return LinearProgressIndicator(
                  minHeight: 8,
                  value: value.webProgress,
                  backgroundColor: Colors.cyan,
                  color: Colors.pinkAccent,
                );
              }
            },
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(homeProvider.searchEngine),
              ),
              onWebViewCreated: (controller) {
                inAppWebViewController = controller;
              },
              pullToRefreshController: pullToRefreshController,
              onLoadStart: (controller, url) {
                Provider.of<HomeProvider>(context, listen: false)
                    .onChangeLoad(true);
              },
              onProgressChanged: (controller, progress) {
                Provider.of<HomeProvider>(context, listen: false)
                    .onWebProgress(progress / 100);
              },
              onLoadStop: (controller, url) {
                Provider.of<HomeProvider>(context, listen: false)
                    .onChangeLoad(false);
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "\t\tSearch or type web address",
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 50)),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onFieldSubmitted: (value) {
                      var url = Uri.parse(value);
                      if (url.scheme.isEmpty) {
                        url = Uri.parse(homeProvider.searchEngine + value);
                      }
                      inAppWebViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(url.toString()),
                        ),
                      );
                      searchController.clear();
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MyWebPage();
                    },
                  ));
                },
                icon: Icon(Icons.home),
                iconSize: 40,
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                onPressed: () async {
                  var url = await inAppWebViewController?.getUrl();
                  if (url != null) {
                    homeProvider.addBookmark(url.toString());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Padding(
                      padding: const EdgeInsets.only(left: 115),
                      child: Text("Bookmarks added"),
                    )));
                  }
                },
                icon: Icon(Icons.bookmark_add_outlined),
                iconSize: 40,
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                onPressed: () {
                  inAppWebViewController?.goBack();
                },
                icon: Icon(Icons.chevron_left),
                iconSize: 40,
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                onPressed: () {
                  inAppWebViewController?.reload();
                },
                icon: Icon(Icons.refresh),
                iconSize: 40,
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                onPressed: () {
                  inAppWebViewController?.goForward();
                },
                icon: Icon(Icons.chevron_right),
                iconSize: 40,
              ),
            ],
          )
        ],
      ),
    );
  }
}
