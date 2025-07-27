


class Skill {
  // each skill consist of these variables.
  String name;
  String level;
  String? imageUrl; // A skill could have no image.

  Skill({
    required this.name,
    this.level = 'Junior',
    this.imageUrl = ''
  });

  // this variable will hold the current skill.
  static Skill currentSkill = Skill(name: 'Self project');

  // this method will set a new current skill.
  static void setCurrentSkill (Skill newSkill){
    currentSkill = newSkill;
  }

  // current skill getter.
  static Skill getCurrentSkill (){
    return currentSkill;
  }

  // // skills list.
  // static List<Skill> skills = [];

  // // add skill method.
  // static void addSkill (Skill skill){
  //   skills.add(skill);
  // }

  // // remove skill method.
  // static void removeSkill (int index){
  //   skills.removeAt(index);
  // }

  // // skills list getter.
  // static List<Skill> getSkills ()
  // {
  //   skills.addAll([
  //     Skill(name: 'Flutter'),
  //     Skill(name: 'English language')
  //   ]);

  //   return skills;
  // }

}