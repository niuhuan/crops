class Crop {
  final int level;
  final String name;
  final int seedPrice;
  final int fruitsMin;
  final int fruitsMax;
  final int fruitPrice;
  final int fruitExp;
  final List<int> stepHours;
  final List<String> stepEmojis;
  final String fruitEmoji;

  const Crop({
    required this.level,
    required this.name,
    required this.seedPrice,
    required this.fruitsMin,
    required this.fruitsMax,
    required this.fruitPrice,
    required this.fruitExp,
    required this.stepHours,
    required this.stepEmojis,
    required this.fruitEmoji,
  });
}

const List<Crop> crops = [
  Crop(
    level: 1,
    name: '西瓜',
    seedPrice: 10,
    fruitsMin: 8,
    fruitsMax: 12,
    fruitPrice: 4,
    fruitExp: 4,
    stepHours: [1, 2, 3],
    stepEmojis: ['🌱', '🌱', '🎍'],
    fruitEmoji: '🍉',
  ),
  Crop(
    level: 2,
    name: '香蕉',
    seedPrice: 20,
    fruitsMin: 10,
    fruitsMax: 15,
    fruitPrice: 8,
    fruitExp: 4,
    stepHours: [1, 2, 3],
    stepEmojis: ['🌱', '🎍', '🎍'],
    fruitEmoji: '🍌',
  ),
  Crop(
    level: 3,
    name: '樱桃',
    seedPrice: 30,
    fruitsMin: 15,
    fruitsMax: 17,
    fruitPrice: 8,
    fruitExp: 4,
    stepHours: [1, 3, 4],
    stepEmojis: ['🌱', '🎍', '🌿'],
    fruitEmoji: '🍒',
  ),
  Crop(
    level: 4,
    name: '番茄',
    seedPrice: 40,
    fruitsMin: 10,
    fruitsMax: 15,
    fruitPrice: 20,
    fruitExp: 9,
    stepHours: [1, 3, 4],
    stepEmojis: ['🌱', '🎍', '🌿'],
    fruitEmoji: '🍅',
  ),
  Crop(
    level: 5,
    name: '茄子',
    seedPrice: 50,
    fruitsMin: 10,
    fruitsMax: 15,
    fruitPrice: 25,
    fruitExp: 12,
    stepHours: [2, 4, 5],
    stepEmojis: ['🌱', '🎍', '🌿'],
    fruitEmoji: '🍆',
  ),
  Crop(
    level: 6,
    name: '辣椒',
    seedPrice: 120,
    fruitsMin: 20,
    fruitsMax: 25,
    fruitPrice: 25,
    fruitExp: 12,
    stepHours: [2, 4, 5],
    stepEmojis: ['🌱', '🎍', '🌾'],
    fruitEmoji: '🌶',
  ),
  Crop(
    level: 7,
    name: '蘑菇',
    seedPrice: 140,
    fruitsMin: 25,
    fruitsMax: 30,
    fruitPrice: 25,
    fruitExp: 12,
    stepHours: [2, 4, 6],
    stepEmojis: ['🌱', '🎍', '🌾'],
    fruitEmoji: '🍄',
  ),
  Crop(
    level: 8,
    name: '玉米',
    seedPrice: 160,
    fruitsMin: 30,
    fruitsMax: 35,
    fruitPrice: 50,
    fruitExp: 20,
    stepHours: [2, 4, 6],
    stepEmojis: ['🌱', '🎍', '🌾'],
    fruitEmoji: '🌽',
  ),
  Crop(
    level: 11,
    name: '苹果',
    seedPrice: 220,
    fruitsMin: 30,
    fruitsMax: 35,
    fruitPrice: 60,
    fruitExp: 30,
    stepHours: [3, 6, 8],
    stepEmojis: ['🌱', '🎍', '🌳'],
    fruitEmoji: '🍎',
  ),
  Crop(
    level: 13,
    name: '雪梨',
    seedPrice: 260,
    fruitsMin: 30,
    fruitsMax: 35,
    fruitPrice: 70,
    fruitExp: 30,
    stepHours: [3, 6, 8],
    stepEmojis: ['🌱', '🎍', '🌳'],
    fruitEmoji: '🍐',
  ),
  Crop(
    level: 15,
    name: '桃子',
    seedPrice: 300,
    fruitsMin: 30,
    fruitsMax: 35,
    fruitPrice: 100,
    fruitExp: 70,
    stepHours: [3, 6, 8],
    stepEmojis: ['🌱', '🎍', '🌳'],
    fruitEmoji: '🍑',
  ),
  Crop(
    level: 17,
    name: '橙子',
    seedPrice: 510,
    fruitsMin: 30,
    fruitsMax: 35,
    fruitPrice: 150,
    fruitExp: 100,
    stepHours: [3, 6, 8],
    stepEmojis: ['🌱', '🎍', '🌳'],
    fruitEmoji: '🍊',
  ),
  Crop(
    level: 19,
    name: '柠檬',
    seedPrice: 999,
    fruitsMin: 30,
    fruitsMax: 35,
    fruitPrice: 200,
    fruitExp: 150,
    stepHours: [3, 6, 8],
    stepEmojis: ['🌱', '🎍', '🌳'],
    fruitEmoji: '🍋',
  ),
];
