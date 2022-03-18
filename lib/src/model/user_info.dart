class UserInfo {
  String? userName;
  String? projectName;
  String? repoUrl;
  String? accessToken;
  String? branchSha1;
  String? currentBranchName;

  UserInfo({
    this.projectName,
    this.repoUrl,
    this.accessToken,
    this.userName,
    this.branchSha1,
    this.currentBranchName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      projectName: json['projectName'],
      repoUrl: json['repoUrl'],
      accessToken: json['accessToken'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'projectName': projectName,
        'repoUrl': repoUrl,
        'accessToken': accessToken,
        'userName': userName,
      };
}
