
import 'package:flutter/material.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/network/network_tool.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/base_page_state.dart';
import 'package:yl_common/widgets/categoryView/common_category_title_view.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_image.dart';
import 'package:yl_common/widgets/common_status_view.dart';
import 'package:yl_common/widgets/common_svg.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_module_service/yl_module_service.dart';
import 'package:yl_theme/yl_theme.dart';
import 'dart:math';

import 'package:yl_usercenter/model/my_assets_entity.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yl_usercenter/model/my_pregod_entity.dart';
import 'package:yl_usercenter/page/usercenter_dynamic_page.dart';
import 'package:yl_usercenter/page/usercenter_dynamic_submodule_page.dart';
import 'package:yl_usercenter/page/usercenter_nft_page.dart';
import 'package:yl_usercenter/yl_usercenter.dart';
import 'package:yl_common/widgets/categoryView/yl_indicator.dart';

import 'package:flutter/services.dart';
import 'package:yl_localizable/yl_localizable.dart';



class UserCenterPage extends StatefulWidget {
  const UserCenterPage({Key? key}) : super(key: key);

  @override
  State<UserCenterPage> createState() => _UserCenterPageState();
}

class _UserCenterPageState extends BasePageState<UserCenterPage> with SingleTickerProviderStateMixin, YLUserInfoObserver, WidgetsBindingObserver{

  MyAssetsEntity? assetsEntity;
  MyPreGod? preGod;
  late ScrollController _nestedScrollController;
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  final GlobalKey globalKey = GlobalKey();
  String? headImgUrl;

  double get _topHeight {
    return kToolbarHeight + Adapt.px(52);
  }

  TabController? _tabController;

  double _scrollY = 0.0;

  @override
  void initState() {
    super.initState();
    bool isLogin = YLUserInfoManager.sharedInstance.isLogin;
    LogUtil.e("==================isLogin : $isLogin");
    // if (isLogin == false) {
    //   _navigateToLoginPage(context);
    // }
    YLUserInfoManager.sharedInstance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
    _getAccountInfoFn();
    _nestedScrollController = ScrollController()
      ..addListener(() {
        // LogUtil.e("_scrollY:");
        if (_nestedScrollController.offset > _topHeight) {
          _scrollY = _nestedScrollController.offset - _topHeight;
          // _contentOnePageKey.currentState?.updateTabbarHeight(_scrollY);
          // _contentTwoPageKey.currentState?.updateTabbarHeight(_scrollY);
          // LogUtil.e("_scrollY:${_scrollY}");
        } else {
          if (_scrollY > 0) {
            _scrollY = 0.0;
            // _contentOnePageKey.currentState?.updateTabbarHeight(_scrollY);
            // _contentTwoPageKey.currentState?.updateTabbarHeight(_scrollY);
          }
        }
      });
    _tabController = TabController(vsync: this, length: 5);
  }

  void _getAccountInfoFn() async {
    // assetsEntity = await getMyAssets();
    // preGod = await getMyPreGods(account: YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944');
    if (mounted) setState(() {});
  }

  _navigateToLoginPage(BuildContext context) async {
    LogUtil.e("_navigateToLoginPage");
    await YLModuleService.pushPage(
      context,
      "yl_login",
      "LoginPage",
      {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '',
        useLargeTitle: false,
        centerTitle: false,
        canBack: false,
      ),
      // body: buildBoby(),
      body:NestedScrollView(
        controller: _nestedScrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: ThemeColor.bgColor,
              pinned: true,
              floating: true,
              expandedHeight: Adapt.px(361),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  //头部整个背景颜色
                  height: double.infinity,
                  color: ThemeColor.bgColor,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: Adapt.px(3),),
                      buildHeadImage(),
                      SizedBox(height: Adapt.px(13),),
                      buildHeadName(),
                      buildHeadDesc(),
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Container(
                  height: 50,
                  color: ThemeColor.bgColor,
                  child: Theme(
                    data: ThemeData(
                        backgroundColor: Colors.transparent,
                        ///点击的高亮颜色
                        highlightColor: Colors.transparent,
                        ///水波纹颜色
                        splashColor: Colors.transparent,
                      ),
                      child: TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: Localized.text("yl_usercenter.全部")),
                        Tab(text: Localized.text("yl_usercenter.交易")),
                        Tab(text: Localized.text("yl_usercenter.捐赠")),
                        Tab(text: Localized.text("yl_usercenter.NFTs")),
                        Tab(text: Localized.text("yl_usercenter.文章")),
                      ],
                      labelStyle: TextStyle(fontSize: 15,color: ThemeColor.titleColor),
                      unselectedLabelStyle: TextStyle(fontSize: 14,color: ThemeColor.gray3),
                      padding: EdgeInsets.only(right: 60),
                      labelPadding: EdgeInsets.only(left: 0, right: 30),
                      indicator: RoundTabIndicator(
                        borderSide: BorderSide(color: Colors.blue, width: 4),
                        gradient: LinearGradient(colors: [
                          Color(0xff44FF35),
                          Color(0xff8792FF),
                          Color(0xffA67EFF)
                        ]),
                        isRound: true,
                        radius: 2,
                        width: 28,
                        insets: EdgeInsets.only(left: 0, right: 30)),
                    ),
                  )
                ),
              ),
            ),
          ];
        },
        body: TabBarView(controller: _tabController, children: [
          // UserCenterNFTPage(),
          UsercenterDynamicSubmodulePage(pageType: DynamicSubmodulePageType.allType,),
          UsercenterDynamicSubmodulePage(pageType: DynamicSubmodulePageType.tradeType,),
          UsercenterDynamicSubmodulePage(pageType: DynamicSubmodulePageType.donateType,),
          UsercenterDynamicSubmodulePage(pageType: DynamicSubmodulePageType.nftType,),
          UsercenterDynamicSubmodulePage(pageType: DynamicSubmodulePageType.articleType,),

        ]),
      ),
      backgroundColor: Colors.white,
    );

    // Scaffold(
    //   appBar: CommonAppBar(
    //     title: '',
    //     useLargeTitle: false,
    //     centerTitle: false,
    //     canBack: false,
    //   ),
    //   // body: buildBoby(),
    //   body: buildMyBoby(),
    //   backgroundColor: Colors.white,
    // );
  }


  Widget buildHeadImage(){
    headImgUrl = 'https://lh3.googleusercontent.com/O_mI3O0zSj99kkhImZl3Wz1NP8ToPcxU3RU_qByy-m4FsD7l3srQkcGQrYnLilZtPyAfWsi-Kte45kz5r57_qO6rzBJSsGFU-eB6lQ=s128';
    final map = <String, String>{};
    String host = getHostUrl(headImgUrl ?? '');
    if(host.length > 0){
      map['Host'] =  host;
      map['User-Agent'] = 'PostmanRuntime/7.26.8';
    }
    return Container(

      child: Center(
        
        child:  Stack(
          children: [
            Container(
              width: Adapt.px(128),
              height: Adapt.px(128),
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.transparent, width: 4,style: BorderStyle.solid),
              //   borderRadius: BorderRadius.circular(Adapt.px(128)),
              //   gradient: SweepGradient(
              //       colors: [ThemeColor.purple1, ThemeColor.purple2,ThemeColor.green1]),
              // ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(Adapt.px(128)),
                child: Image.asset(
                  'assets/images/logo_icon.png',
                  fit: BoxFit.contain,
                  width: Adapt.px(128),
                  height: Adapt.px(128),
                  package: 'yl_login',
                )
                // CachedNetworkImage(
                //   imageUrl: headImgUrl ?? '',
                //   placeholder: (context, url) =>  Container(
                //     color: ThemeColor.gray3,
                //   ),
                //   errorWidget: (context, url, error) => Container(
                //     color: Colors.transparent,
                //   ),
                //   // width: Adapt.px(100),
                //   // height: Adapt.px(130),
                //   fit: BoxFit.fill,
                //   width: Adapt.px(128),
                //   height: Adapt.px(128),
                //   httpHeaders: map,
                // ),
              ),
            ),
            CommonSVG(
              iconName: 'biankuan.svg',
            ),
          ],
        ),


      ),
    );
  }

  Widget buildHeadName(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Adeline Dean",style: TextStyle(color: ThemeColor.titleColor, fontSize: 16),),
        // Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(color: Colors.transparent, width: 1,style: BorderStyle.solid),
        //     borderRadius: BorderRadius.circular(Adapt.px(18)),
        //     color: ThemeColor.yellow1,
        //   ),
        //   child: Text(
        //     "27.6k热度",style: TextStyle(color: ThemeColor.titleColor, fontSize: 12),
        //   ),
        //   padding: EdgeInsets.only(left: 7,right: 7),
        //   margin: EdgeInsets.only(left: 5),
        // )
      ],
    );
  }

  Widget buildHeadDesc() {
    // String address = "0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944";
    String address = YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944';
    String addressFoot = address.substring(address.length - 4);
    String addressHead = address.substring(0, 6);
    String showAddress = '${addressHead}...${addressFoot}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: Adapt.px(6),
        ),
        Container(
            margin: EdgeInsets.only(left: Adapt.px(52), right: Adapt.px(52)),
            child: Wrap(
              children: [
                Text(
                  "\$MEME community, Building @swapxsite @0x_Chat Can devs do something?",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ThemeColor.gray3, fontSize: 12),
                ),
              ],
            )),
        SizedBox(
          height: Adapt.px(9),
        ),
        GestureDetector(
          child: Center(
            child: Container(
              width: Adapt.px(158),
              height: Adapt.px(35),
              decoration: BoxDecoration(
                color: ThemeColor.purple2,
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: Adapt.px(16),
                  ),
                  Expanded(
                      child: Text(
                        showAddress,
                        style: TextStyle(color: ThemeColor.gray3, fontSize: 16),
                    // overflow: TextOverflow.ellipsis,
                  )),
                  SizedBox(
                    width: Adapt.px(4),
                  ),
                  CommonImage(
                    iconName: "icon_copy.png",
                    width: Adapt.px(23),
                    height: Adapt.px(23),
                  ),
                  SizedBox(
                    width: Adapt.px(9),
                  )
                ],
              ),
            ),
          ),
          onTap: () {
            //点击复制
            Clipboard.setData(ClipboardData(text:address));
          },
        )
      ],
      textBaseline: TextBaseline.alphabetic,
    );
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  @override
  void didLoginSuccess(YLUserInfo? userInfo) {
    if (this.mounted) {
      setState(() {

      });
    }
  }

  String getHostUrl(String url){
    RegExp regExp = new RegExp(r"^.*?://(.*?)/.*?$");
    RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return '';
  }

  // Widget buildMyBoby(){
  //   final size = MediaQuery.of(context).size;
  //   final width = size.width;
  //   final height = size.height;
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CommonCategoryTitleView(
  //         onTap: (value) {
  //           setState(() {
  //             selectedIndex = value;
  //           });
  //           _pageController.animateToPage(
  //             selectedIndex,
  //             duration: const Duration(milliseconds: 10),
  //             curve: Curves.linear,
  //           );
  //         },
  //         width: 260,
  //         selectedIndex: selectedIndex,
  //         unselectedColor: Color(0xFF8C8C8C),
  //         selectedColor: Color(0xFF000000),
  //         gradient: LinearGradient(colors: [Color(0xff44FF35), Color(0xff8792FF),Color(0xffA67EFF)]),
  //         items: [
  //           CommonCategoryTitleItem(
  //             title: '0xChat',
  //             selectedIconName: '',
  //             unSelectedIconName: ''),
  //           CommonCategoryTitleItem(
  //             title: '通讯录',
  //             selectedIconName: '',
  //             unSelectedIconName: ''),
  //           CommonCategoryTitleItem(
  //             title: '发现',
  //             selectedIconName: '',
  //             unSelectedIconName: ''),
  //           CommonCategoryTitleItem(
  //             title: '我',
  //             selectedIconName: '',
  //             unSelectedIconName: ''),
  //         ],
  //       ),
  //
  //       Container(
  //         width: width,
  //         height: height - 45 - kToolbarHeight - MediaQuery.of(context).padding.top,
  //         child: AspectRatio(
  //           aspectRatio: 1,
  //           child: PageView(
  //             physics: const AlwaysScrollableScrollPhysics(),
  //             controller: _pageController,
  //             onPageChanged: (value) {
  //               setState(() {
  //                 selectedIndex = value;
  //               });
  //               _pageController.animateToPage(
  //                 selectedIndex,
  //                 duration: const Duration(milliseconds: 10),
  //                 curve: Curves.linear,
  //               );
  //             },
  //             children: [
  //               Container(
  //                 color: Colors.black,
  //                 constraints: const BoxConstraints.expand(
  //                   width: double.infinity, height: double.infinity),
  //                 child: Image(
  //                   image: AssetImage('assets/images/5.png'),
  //                   fit: BoxFit.fill,
  //                 ),
  //               ),
  //               Container(
  //                 color: Colors.blue,
  //                 constraints: const BoxConstraints.expand(
  //                   width: double.infinity, height: double.infinity),
  //                 child:Image(
  //                   image: AssetImage('assets/images/4.png'),
  //                   fit: BoxFit.fill,
  //                 ),
  //               ),
  //               Container(
  //                 color: Colors.green,
  //                 child: Container(
  //                   child: Image(
  //                     image: AssetImage('assets/images/6.png'),
  //                     fit: BoxFit.fill,
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 color: Colors.yellow,
  //                 constraints: const BoxConstraints.expand(
  //                   width: double.infinity, height: double.infinity),
  //                 child: const Center(
  //                   child: Image(
  //                     image: AssetImage('assets/images/7.png'),
  //                     fit: BoxFit.fitHeight,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }


  Widget buildBoby(){
    // LogUtil.e('Bison=====1== ${assetsEntity?.assets?.length}');
    return  assetsEntity == null ? Container() : Container(
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        itemBuilder: (context, index) {

          return ImageTile(
            index: index,
            width: 100,
            height: 130,
            imgUrl: assetsEntity?.assets?[index].imageThumbnailUrl ?? '',
          );
        },
        itemCount: assetsEntity?.assets?.length,
      ),
    );
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
    required this.index,
    required this.width,
    required this.height,
    required this.imgUrl,
  }) : super(key: key);

  final int index;
  final int width;
  final int height;
  final String imgUrl;
  @override
  Widget build(BuildContext context) {

    final map = <String, String>{};
    String host = getHostUrl(imgUrl);
    if(host.length > 0){
      map['Host'] =  host;
      map['User-Agent'] = 'PostmanRuntime/7.26.8';
    }
    // LogUtil.e('Bison======= ${host} =====  ${imgUrl}');
    return ClipRRect(
        borderRadius: BorderRadius.circular(Adapt.px(23)),
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          placeholder: (context, url) => Container(
            color: ThemeColor.gray3,
          ),
          errorWidget: (context, url, error) => Container(
            color: ThemeColor.gray3,
          ),
          // width: Adapt.px(100),
          // height: Adapt.px(130),
          fit: BoxFit.contain,
          httpHeaders: map,
        ));

    return Image.network(
      'https://picsum.photos/$width/$height?random=$index',
      width: width.toDouble(),
      height: height.toDouble(),
      fit: BoxFit.cover,
    );
  }
  String getHostUrl(String url){
    RegExp regExp = new RegExp(r"^.*?://(.*?)/.*?$");
    RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return '';
  }
}