import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/network/network_general.dart';
import 'package:yl_network/network_manager.dart';

class MyPreGod {
  MyPreGod({
      String? version, 
      String? dateUpdated, 
      String? identifier, 
      int? total, 
      List<PreGodList>? list,}){
    _version = version;
    _dateUpdated = dateUpdated;
    _identifier = identifier;
    _total = total;
    _list = list;
}

  MyPreGod.fromJson(dynamic json) {
    _version = json['version'];
    _dateUpdated = json['date_updated'];
    _identifier = json['identifier'];
    _total = json['total'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list?.add(PreGodList.fromJson(v));
      });
    }
  }
  String? _version;
  String? _dateUpdated;
  String? _identifier;
  int? _total;
  List<PreGodList>? _list;
MyPreGod copyWith({  String? version,
  String? dateUpdated,
  String? identifier,
  int? total,
  List<PreGodList>? list,
}) => MyPreGod(  version: version ?? _version,
  dateUpdated: dateUpdated ?? _dateUpdated,
  identifier: identifier ?? _identifier,
  total: total ?? _total,
  list: list ?? _list,
);
  String? get version => _version;
  String? get dateUpdated => _dateUpdated;
  String? get identifier => _identifier;
  int? get total => _total;
  List<PreGodList>? get list => _list;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['version'] = _version;
    map['date_updated'] = _dateUpdated;
    map['identifier'] = _identifier;
    map['total'] = _total;
    if (_list != null) {
      map['list'] = _list?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// 账户信息接口
Future<MyPreGod?> getMyPreGods({BuildContext? context, Map<String, dynamic>? params, String? account}) async {
  final map = <String, dynamic>{};
  // map['X-API-KEY'] = 'a34f499e3db94c2ebaea8b1ba53fc721';
  // 'https://pregod.rss3.dev/v0.4.0/account:0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944@ethereum/notes?tags=NFT&exclude_tags=POAP'
  String url = 'https://pregod.rss3.dev/v0.4.0/account:${account}@ethereum/notes';
  return YLNetwork.instance.doRequest(
    context,
    url: url,
    // header: map,
    showErrorToast: true,
    needCommonParams: false,
    needRSA: false,
    type: RequestType.GET,
    params: params
  ).then((YLResponse response){
    if (response.data is Map) {
      MyPreGod assetsEntity = MyPreGod.fromJson(Map<String, dynamic>.from(response.data));
      return assetsEntity;
    }
    return null;
  }).catchError((e) {
    LogUtil.e("error=============xxxxxxxxxxxxxxx : ${e}  ===  $params");
    return null;
  });
}

/// identifier : "rss3://note:0x5ea8f56301482e1583ac4f78dfab3b93db90b2a0ef4e9a4fa73fe0ba8136a89b-67-104577845207406739233498577831854075688817521750848206372017175842561722417261@ethereum"
/// date_created : "2022-06-17T22:38:34.000Z"
/// date_updated : "2022-06-17T22:38:34.000Z"
/// related_urls : ["https://etherscan.io/tx/0x5ea8f56301482e1583ac4f78dfab3b93db90b2a0ef4e9a4fa73fe0ba8136a89b","https://etherscan.io/nft/0xf1c121a563a84d62a5f11152d064dd0d554024f9/104577845207406739233498577831854075688817521750848206372017175842561722417261","https://opensea.io/assets/0xf1c121a563a84d62a5f11152d064dd0d554024f9/104577845207406739233498577831854075688817521750848206372017175842561722417261"]
/// links : "rss3://note:0x5ea8f56301482e1583ac4f78dfab3b93db90b2a0ef4e9a4fa73fe0ba8136a89b-67-104577845207406739233498577831854075688817521750848206372017175842561722417261@ethereum/links"
/// backlinks : "rss3://note:0x5ea8f56301482e1583ac4f78dfab3b93db90b2a0ef4e9a4fa73fe0ba8136a89b-67-104577845207406739233498577831854075688817521750848206372017175842561722417261@ethereum/backlinks"
/// tags : ["NFT"]
/// authors : ["rss3://account:0xc8b960d09c0078c18dcbe7eb9ab9d816bcca8944@ethereum"]
/// title : "Ethereum Since 2021"
/// summary : "Owning this badge indicates that the user has created the first Ethereum transaction in 2021. Each badges are non-transferable NFTs, and can only be earned by validating user’s historic on-chain actions.\n\nTo earn this badge, visit https://noox.world and prove your on-chain achievement. Powered by Noox Protocol."
/// attachments : [{"type":"preview","address":"ipfs://bafybeifu42jecmhd4l7snyhgugobq36c2uvbhmlyquo4la4thpvfr7ny6i","mime_type":""},{"type":"attributes","content":"[{\"trait_type\":\"category\",\"value\":\"General\"},{\"trait_type\":\"project\",\"value\":\"Ethereum\"},{\"trait_type\":\"required_action\",\"value\":\"Generate the first transaction\"},{\"trait_type\":\"criterion\",\"value\":\"in 2021\"},{\"trait_type\":\"project_url\",\"value\":\"https://ethereum.org/\"},{\"trait_type\":\"eligibility_rules_url\",\"value\":\"ipfs://bafkreihsa2t2z33ai3nnwm4q73e3qk445qip5glxkmhjq6wdbji76ejp2m\"}]","mime_type":"text/json"}]
/// source : "Ethereum NFT"
/// metadata : {"collection_address":"0xf1c121a563a84d62a5f11152d064dd0d554024f9","collection_name":"","contract_type":"ERC1155","from":"0x0000000000000000000000000000000000000000","log_index":"67","network":"ethereum","proof":"0x5ea8f56301482e1583ac4f78dfab3b93db90b2a0ef4e9a4fa73fe0ba8136a89b-67-104577845207406739233498577831854075688817521750848206372017175842561722417261","to":"0xc8b960d09c0078c18dcbe7eb9ab9d816bcca8944","token_id":"104577845207406739233498577831854075688817521750848206372017175842561722417261","token_standard":"ERC1155","token_symbol":""}

class PreGodList {
  PreGodList({
      String? identifier, 
      String? dateCreated, 
      String? dateUpdated, 
      List<String>? relatedUrls, 
      String? links, 
      String? backlinks, 
      List<String>? tags, 
      List<String>? authors, 
      String? title, 
      String? summary, 
      List<Attachments>? attachments, 
      String? source, 
      Metadata? metadata,
      String? showType, //0默认展示  1 展示交易类型的   2 展示带有图片的
    //捐赠
    //
    // tags Donation
    //
    // ///文章
    // tags Mirror Entry
    //
    // ///交易
    // attachments == null
    //
    // nft
    //
    // tags ETH ||  NFT  &&  attachments ！= null

      String? metaType,// 0 nft  1 交易  2 捐赠  3 文章
    String? imgUrl, //图片展示链接
  }){
    _identifier = identifier;
    _dateCreated = dateCreated;
    _dateUpdated = dateUpdated;
    _relatedUrls = relatedUrls;
    _links = links;
    _backlinks = backlinks;
    _tags = tags;
    _authors = authors;
    _title = title;
    _summary = summary;
    _attachments = attachments;
    _source = source;
    _metadata = metadata;
    _showType = showType;
    _metaType = metaType;
    _imgUrl = imgUrl;
}

  PreGodList.fromJson(dynamic json) {
    _identifier = json['identifier'];
    _dateCreated = json['date_created'];
    _dateUpdated = json['date_updated'];
    _relatedUrls = json['related_urls'] != null ? json['related_urls'].cast<String>() : [];
    _links = json['links'];
    _backlinks = json['backlinks'];
    _tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    _authors = json['authors'] != null ? json['authors'].cast<String>() : [];
    _title = json['title'];
    _summary = json['summary'];
    if (json['attachments'] != null) {
      _attachments = [];
      json['attachments'].forEach((v) {
        _attachments?.add(Attachments.fromJson(v));
      });
    }
    _source = json['source'];
    _metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    // _metaType = "0";
    if(tags != null && _tags!.contains("Donation")){
      _metaType = "2";//捐赠
    }
    else if(tags != null && _tags!.contains("Mirror Entry")){
      _metaType = "3";//文章
    }
    else if (json['attachments'] == null && _metadata?.tokenAddress != null) {//交易
      _metaType = "1";//交易
      // print("tokenAddress xxx==== ${ _metadata?.tokenAddress}");
    }

    else if (json['attachments'] != null && (tags != null && (_tags!.contains("NFT"))) && _metadata?.tokenAddress == null) {//NFT
      _metaType = "4";//NFT
      // print("tokenAddress ${ _metadata?.tokenAddress}");
    }
    // print("_metaType: ${_metaType}");
    _showType = "0";
    if(_metaType == "1"){
      _showType = "1";//交易
    }
    // if(_metaType == "1"){
    //   _showType = "1";//捐赠
    // }
    if(json['attachments'] != null){
      _attachments!.forEach((element) {
        if(element.type == "logo" && element.address != null){ //捐赠展示图片
          _showType = "2";//
          _imgUrl = element.address;
        }
        if(element.type == "preview" && element.address != null){//nft 图片展示
          _showType = "2";
          String temStr = "";
          bool isIpfs = element.address!.contains("ipfs://");
          bool isHttp = element.address!.contains("http");
          if(isIpfs){
            temStr = element.address!.replaceAll("ipfs://", "https://infura-ipfs.io/ipfs/");
          }
          if(isHttp){
            temStr = element.address!;
          }
          //ipfs://bafybeifu42jecmhd4l7snyhgugobq36c2uvbhmlyquo4la4thpvfr7ny6i
          //https://infura-ipfs.io/ipfs/bafybeifu42jecmhd4l7snyhgugobq36c2uvbhmlyquo4la4thpvfr7ny6i
          _imgUrl = temStr;
          // LogUtil.e('_imgUrl====== ==    $_imgUrl       ======  ${element.address}');
        }
      });
    }
  }
  String? _identifier;
  String? _dateCreated;
  String? _dateUpdated;
  List<String>? _relatedUrls;
  String? _links;
  String? _backlinks;
  List<String>? _tags;
  List<String>? _authors;
  String? _title;
  String? _summary;
  List<Attachments>? _attachments;
  String? _source;
  Metadata? _metadata;
  String? _showType;
  String? _metaType;
  String? _imgUrl;
  PreGodList copyWith({  String? identifier,
  String? dateCreated,
  String? dateUpdated,
  List<String>? relatedUrls,
  String? links,
  String? backlinks,
  List<String>? tags,
  List<String>? authors,
  String? title,
  String? summary,
  List<Attachments>? attachments,
  String? source,
  Metadata? metadata,
  String? showType,
  String? metaType,
  String? imgUrl,
  }) => PreGodList(  identifier: identifier ?? _identifier,
  dateCreated: dateCreated ?? _dateCreated,
  dateUpdated: dateUpdated ?? _dateUpdated,
  relatedUrls: relatedUrls ?? _relatedUrls,
  links: links ?? _links,
  backlinks: backlinks ?? _backlinks,
  tags: tags ?? _tags,
  authors: authors ?? _authors,
  title: title ?? _title,
  summary: summary ?? _summary,
  attachments: attachments ?? _attachments,
  source: source ?? _source,
  metadata: metadata ?? _metadata,
  showType: showType ?? _showType,
  metaType: metaType ?? _metaType,
  imgUrl: imgUrl ?? _imgUrl,
);
  String? get identifier => _identifier;
  String? get dateCreated => _dateCreated;
  String? get dateUpdated => _dateUpdated;
  List<String>? get relatedUrls => _relatedUrls;
  String? get links => _links;
  String? get backlinks => _backlinks;
  List<String>? get tags => _tags;
  List<String>? get authors => _authors;
  String? get title => _title;
  String? get summary => _summary;
  List<Attachments>? get attachments => _attachments;
  String? get source => _source;
  Metadata? get metadata => _metadata;
  String? get showType => _showType;
  String? get metaType => _metaType;
  String? get imgUrl => _imgUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identifier'] = _identifier;
    map['date_created'] = _dateCreated;
    map['date_updated'] = _dateUpdated;
    map['related_urls'] = _relatedUrls;
    map['links'] = _links;
    map['backlinks'] = _backlinks;
    map['tags'] = _tags;
    map['authors'] = _authors;
    map['title'] = _title;
    map['summary'] = _summary;
    if (_attachments != null) {
      map['attachments'] = _attachments?.map((v) => v.toJson()).toList();
    }
    map['source'] = _source;
    if (_metadata != null) {
      map['metadata'] = _metadata?.toJson();
    }
    map['showType'] = _showType;
    map['metaType'] = _metaType;
    map['imgUrl'] = _imgUrl;
    return map;
  }

}

/// collection_address : "0xf1c121a563a84d62a5f11152d064dd0d554024f9"
/// collection_name : ""
/// contract_type : "ERC1155"
/// from : "0x0000000000000000000000000000000000000000"
/// log_index : "67"
/// network : "ethereum"
/// proof : "0x5ea8f56301482e1583ac4f78dfab3b93db90b2a0ef4e9a4fa73fe0ba8136a89b-67-104577845207406739233498577831854075688817521750848206372017175842561722417261"
/// to : "0xc8b960d09c0078c18dcbe7eb9ab9d816bcca8944"
/// token_id : "104577845207406739233498577831854075688817521750848206372017175842561722417261"
/// token_standard : "ERC1155"
/// token_symbol : ""

class Metadata {
  Metadata({
      String? collectionAddress, 
      String? collectionName, 
      String? contractType, 
      String? from, 
      String? logIndex,
      String? network, 
      String? proof, 
      String? to, 
      String? tokenId, 
      String? tokenStandard, 
      String? tokenSymbol,
    String?  amount,
    int? decimal,
    String? tokenAddress,
  }){
    _collectionAddress = collectionAddress;
    _collectionName = collectionName;
    _contractType = contractType;
    _from = from;
    _logIndex = logIndex;
    _network = network;
    _proof = proof;
    _to = to;
    _tokenId = tokenId;
    _tokenStandard = tokenStandard;
    _tokenSymbol = tokenSymbol;
    _amount = amount;
    _decimal = decimal;
    _tokenAddress = tokenAddress;
}

  Metadata.fromJson(dynamic json) {
    _collectionAddress = json['collection_address'];
    _collectionName = json['collection_name'];
    _contractType = json['contract_type'];
    _from = json['from'];
    // _logIndex = json['log_index'];
    _network = json['network'];
    _proof = json['proof'];
    _to = json['to'];
    _tokenId = json['token_id'];
    _tokenStandard = json['token_standard'];
    _tokenSymbol = json['token_symbol'];
    _amount = json['amount'];
    _decimal = json['decimal'];
    _tokenAddress = json['token_address'];
  }
  String? _collectionAddress;
  String? _collectionName;
  String? _contractType;
  String? _from;
  String? _logIndex;
  String? _network;
  String? _proof;
  String? _to;
  String? _tokenId;
  String? _tokenStandard;
  String? _tokenSymbol;
  String?  _amount;
  int? _decimal;
  String?_tokenAddress;
Metadata copyWith({  String? collectionAddress,
  String? collectionName,
  String? contractType,
  String? from,
  String? logIndex,
  String? network,
  String? proof,
  String? to,
  String? tokenId,
  String? tokenStandard,
  String? decimaltokenSymbol,
  String? amount,
  int? decimal,
  String? tokenAddress,
}) => Metadata(  collectionAddress: collectionAddress ?? _collectionAddress,
  collectionName: collectionName ?? _collectionName,
  contractType: contractType ?? _contractType,
  from: from ?? _from,
  logIndex: logIndex ?? _logIndex,
  network: network ?? _network,
  proof: proof ?? _proof,
  to: to ?? _to,
  tokenId: tokenId ?? _tokenId,
  tokenStandard: tokenStandard ?? _tokenStandard,
  tokenSymbol: tokenSymbol ?? _tokenSymbol,
  amount: amount ?? _amount,
  decimal: decimal ?? _decimal,
  tokenAddress: tokenAddress ?? _tokenAddress,
);
  String? get collectionAddress => _collectionAddress;
  String? get collectionName => _collectionName;
  String? get contractType => _contractType;
  String? get from => _from;
  String? get logIndex => _logIndex;
  String? get network => _network;
  String? get proof => _proof;
  String? get to => _to;
  String? get tokenId => _tokenId;
  String? get tokenStandard => _tokenStandard;
  String? get tokenSymbol => _tokenSymbol;
  String? get amount => _amount;
  int? get decimal => _decimal;
  String? get tokenAddress => _tokenAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['collection_address'] = _collectionAddress;
    map['collection_name'] = _collectionName;
    map['contract_type'] = _contractType;
    map['from'] = _from;
    map['log_index'] = _logIndex;
    map['network'] = _network;
    map['proof'] = _proof;
    map['to'] = _to;
    map['token_id'] = _tokenId;
    map['token_standard'] = _tokenStandard;
    map['token_symbol'] = _tokenSymbol;

    map['amount'] = _amount;
    map['decimal'] = _decimal;
    map['token_address'] = _tokenAddress;
    return map;
  }

}

/// type : "preview"
/// address : "ipfs://bafybeifu42jecmhd4l7snyhgugobq36c2uvbhmlyquo4la4thpvfr7ny6i"
/// mime_type : ""

class Attachments {
  Attachments({
      String? type,
      String? address, 
      String? mimeType,
  }){
    _type = type;
    _address = address;
    _mimeType = mimeType;
}

  Attachments.fromJson(dynamic json) {
    _type = json['type'];
    _address = json['address'];
    _mimeType = json['mime_type'];
  }
  String? _type;
  String? _address;
  String? _mimeType;
Attachments copyWith({  String? type,
  String? address,
  String? mimeType,
}) => Attachments(  type: type ?? _type,
  address: address ?? _address,
  mimeType: mimeType ?? _mimeType,
);
  String? get type => _type;
  String? get address => _address;
  String? get mimeType => _mimeType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // map['type'] = _type;
    // map['address'] = _address;
    // map['mime_type'] = _mimeType;
    return map;
  }

}