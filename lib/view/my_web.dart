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
                    child: GestureDetector(
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
                                          homeProvider.removeBookmark(
                                              homeProvider.bookmarks[index]);
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
                                            },
                                            icon: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(Icons.close)),
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
                          Icon(Icons.bookmark),
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
                                  ListTile(
                                    leading: Icon(Icons.search),
                                    title: Text('Google'),
                                    onTap: () {
                                      homeProvider
                                          .setSearchEngine(1); // Set to Google
                                      inAppWebViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                          url:
                                              WebUri(homeProvider.searchEngine),
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.search),
                                    title: Text('Yahoo'),
                                    onTap: () {
                                      homeProvider
                                          .setSearchEngine(2); // Set to Yahoo
                                      inAppWebViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                          url:
                                              WebUri(homeProvider.searchEngine),
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.search),
                                    title: Text('Bing'),
                                    onTap: () {
                                      homeProvider
                                          .setSearchEngine(3); // Set to Bing
                                      inAppWebViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                          url:
                                              WebUri(homeProvider.searchEngine),
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.search),
                                    title: Text('DuckDuckGo'),
                                    onTap: () {
                                      homeProvider.setSearchEngine(
                                          4); // Set to DuckDuckGo
                                      inAppWebViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                          url:
                                              WebUri(homeProvider.searchEngine),
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.screen_search_desktop_outlined),
                          SizedBox(width: 10),
                          Text('Search Engine'),
                        ],
                      ),
                    ),
                    value: 'search_engine',
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
                color: Colors.blue,
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
              tileColor: Colors.blue,
              title: Text(
                "Choose the Search Engine",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.search),
                              title: Text('Google'),
                              onTap: () {
                                homeProvider
                                    .setSearchEngine(1); // Set to Google
                                inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                    url: WebUri(homeProvider.searchEngine),
                                  ),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.search),
                              title: Text('Yahoo'),
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
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.search),
                              title: Text('Bing'),
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
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.search),
                              title: Text('DuckDuckGo'),
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Divider(),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<ThemeProvider>(
                builder: (BuildContext context, themeProvider, Widget? child) {
                  return Row(
                    children: [
                      Text(
                        "Theme :",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton(
                        dropdownColor: Colors.black38,
                        value: themeProvider.themeMode,
                        items: [
                          DropdownMenuItem(child: Text("System"), value: 0),
                          DropdownMenuItem(child: Text("Light"), value: 1),
                          DropdownMenuItem(child: Text("Dark"), value: 2),
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
            SizedBox(
              height: 383.5,
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
                    onChanged: (value) {
                      String search =
                          "${homeProvider.searchEngine}search?q=$value";
                      inAppWebViewController?.loadUrl(
                          urlRequest: URLRequest(url: WebUri(search)));
                    },
                    onFieldSubmitted: (value) {
                      String search =
                          "${homeProvider.searchEngine}search?q=$value";
                      inAppWebViewController?.loadUrl(
                          urlRequest: URLRequest(url: WebUri(search)));
                    },
                    decoration: InputDecoration(
                        labelText: "\t\tSearch or type web address",
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 50))),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
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
                  }
                },
                icon: Icon(Icons.bookmark_add_outlined),
                iconSize: 40,
              ),
              SizedBox(
                width: 15,
              ),
              IconButton(
                onPressed: () {
                  inAppWebViewController?.goBack();
                },
                icon: Icon(Icons.chevron_left),
                iconSize: 40,
              ),
              SizedBox(
                width: 10,
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
