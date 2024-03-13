// Kelas untuk merepresentasikan karakter dalam permainan
class Character {
  String name;
  String gender;
  String weapon;
  String role;
  int hp;
  int atk;

  // Konstruktor untuk membuat objek karakter
  Character(this.name, this.gender, this.weapon, this.role, this.hp, this.atk);

  // Metode untuk menyerang karakter target
  Future<void> attack(Character target) async {
    print('$name attacks ${target.name}!');
    await target.takeDamage(atk);
  }

  // Metode untuk mengurangi HP karakter saat menerima serangan
  Future<void> takeDamage(int damage) async {
    hp -= damage;
    print('$name takes $damage damage!');
  }

  // Metode untuk merepresentasikan karakter dalam bentuk string
  @override
  String toString() {
    return '$name ($gender) - Role: $role, Weapon: $weapon, HP: $hp, ATK: $atk';
  }
}

// Kelas untuk merepresentasikan karakter pemain dalam permainan
class Player extends Character {
  late Inventory inventory;

  // Konstruktor untuk membuat objek pemain
  Player(
      String name, String gender, String weapon, String role, int hp, int atk)
      : super(name, gender, weapon, role, hp, atk) {
    inventory = Inventory();
  }

  // Metode untuk menambahkan item ke inventaris pemain
  void addToInventory(Item item) {
    inventory.addItem(item);
  }

  // Metode untuk menggunakan item dari inventaris pemain
  Future<void> useItem(Item item) async {
    if (inventory.contains(item)) {
      print('$name uses ${item.name}!');
      // Hapus item dari inventaris pemain setelah digunakan
      await inventory.removeItem(item);
    } else {
      print('$name does not have ${item.name} in inventory!');
    }
  }

  // Merepresentasikan karakter pemain dalam bentuk string
  @override
  String toString() {
    return super.toString() + ', Inventory: $inventory';
  }
}

// Kelas untuk merepresentasikan karakter non-pemain dalam permainan
class NPC extends Character {
  bool friendly;

  // Konstruktor untuk membuat objek NPC
  NPC(String name, String gender, String role, String weapon, int hp, int atk,
      this.friendly)
      : super(name, gender, weapon, role, hp, atk);

  // Metode untuk berinteraksi dengan NPC
  void interact() {
    if (friendly) {
      print('$name says: Hello traveler!');
    } else {
      print('$name attacks!');
    }
  }

  // Merepresentasikan NPC dalam bentuk string
  @override
  String toString() {
    return super.toString() + ', Friendly: $friendly';
  }
}

// Kelas untuk merepresentasikan musuh dalam permainan
class Enemy extends NPC {
  // Konstruktor untuk membuat objek musuh
  Enemy(String name, String gender, String weapon, String role, int hp, int atk)
      : super(name, gender, role, weapon, hp, atk, false);

  // Metode untuk mengurangi HP musuh saat menerima serangan
  @override
  Future<void> takeDamage(int damage) async {
    await super.takeDamage(damage);
    if (hp <= 0) {
      print('$name is defeated!');
    }
  }
}

// Kelas untuk merepresentasikan item dalam permainan
class Item {
  String name;

  // Konstruktor untuk membuat objek item
  Item(this.name);

  // Merepresentasikan item dalam bentuk string
  @override
  String toString() {
    return name;
  }
}

// Kelas untuk menyimpan item-item dalam inventaris pemain
class Inventory {
  List<Item> items = [];

  // Metode untuk menambahkan item ke inventaris
  void addItem(Item item) {
    items.add(item);
  }

  // Metode untuk menghapus item dari inventaris
  Future<void> removeItem(Item item) async {
    items.remove(item);
  }

  // Metode untuk memeriksa apakah item tertentu ada dalam inventaris
  bool contains(Item item) {
    return items.contains(item);
  }

  // Merepresentasikan inventaris dalam bentuk string
  @override
  String toString() {
    return items.toString();
  }
}

// Fungsi utama untuk menjalankan program
void main() async {
  // Inisialisasi karakter
  var nova = Player('Nova', 'M', 'Bow', 'DPS', 100, 20);
  var jane = Player('Jane', 'F', 'Magic Staff', 'Healer', 80, 10);
  var adrian = NPC('Adrian', 'M', 'Quest Giver', '', 0, 0, true);
  var thor = Enemy('Thor', 'M', 'Hammer', 'Boss', 200, 30);

  // Menambahkan item ke inventaris pemain
  nova.addToInventory(Item('Arrow'));
  nova.addToInventory(Item('Coin'));

  // Menampilkan informasi karakter sebelum pertarungan
  print('Before Battle:');
  print(nova);
  print(jane);
  print(adrian);
  print(thor);
  print('');

  // Pertarungan dimulai
  print('Battle Begins!\n');

  // Nova menyerang Thor
  await nova.attack(thor);
  // Thor menyerang Nova
  await thor.attack(nova);
  // Jane menggunakan Potion untuk menyembuhkan dirinya
  await jane.useItem(Item('Potion'));
  // Nova menyerang Thor lagi
  await nova.attack(thor);
  // Thor menyerang Nova lagi
  await thor.attack(nova);

  // Menampilkan informasi karakter setelah pertarungan
  print('\nAfter Battle:');
  print(nova);
  print(jane);
  print(adrian);
  print(thor);
}
