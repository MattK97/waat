enum Tier { BASE, PLUS, PREMIUM }

class Team {
  String name;
  String teamId;
  bool usesWorkTime;
  String creatorID;
  String entryCode;
  Tier tier;

  Team({this.name, this.teamId, this.usesWorkTime, this.creatorID, this.tier});

  Team.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    teamId = json['team_id'];
    usesWorkTime = json['uses_worktime'];
    creatorID = json['creator_id'];
    entryCode = json['team_entry_code'];
    tier = Tier.values.byName(json['tier']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['team_id'] = this.teamId;
    data['uses_worktime'] = this.usesWorkTime;
    data['creator_id'] = this.creatorID;
    data['team_entry_code'] = this.entryCode;
    data['tier'] = this.tier;
    return data;
  }
}
