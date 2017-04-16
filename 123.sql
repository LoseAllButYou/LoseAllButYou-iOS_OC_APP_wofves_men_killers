--
-- 由SQLiteStudio v3.1.0 产生的文件 周日 4月 16 04:06:21 2017
--
-- 文本编码：UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- 表：game_identity
CREATE TABLE game_identity (id INTEGER PRIMARY KEY AUTOINCREMENT, identity TEXT NOT NULL, func_description TEXT DEFAULT 没有, image_name VARCHAR);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (0, '狼人', '在天黑的时候负责杀人。不同的轮数可以杀同一个人，白天可以自爆', 'wolf.jpg');
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (1, '女巫', '在整个游戏环节里边只有一瓶毒药，一瓶解药。第一晚能自救', 'witch.jpg');
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (2, '上帝', '主持整个游戏的人。
不参与到具体的游戏之中。', 'god.jpg');
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (3, '预言家', '在每一轮的环节里，都能验明一个人的身份。', 'seer.jpg');
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (4, '守卫', '在每一轮中都能守护一个人，但是同一个人不能连续守二次。也可以选择不守卫', 'savior.jpg');
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (5, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (6, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (7, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (8, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (9, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (10, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (11, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (12, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (13, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (14, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (15, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (16, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (17, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (18, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (19, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (20, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (21, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (22, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (23, '123', '没有', NULL);
INSERT INTO game_identity (id, identity, func_description, image_name) VALUES (24, '123', '没有', NULL);

-- 表：history_info
CREATE TABLE history_info (history_id INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT REPLACE, user_id INTEGER REFERENCES user_info (user_id), game_date TIME UNIQUE ON CONFLICT REPLACE NOT NULL COLLATE RTRIM DEFAULT (datetime('now', 'localtime')));

-- 表：user_info
CREATE TABLE user_info (user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE ON CONFLICT REPLACE, user_name VARCHAR NOT NULL, game_identity VARCHAR, die_day INT (0, 10), die_way INT (0, 100), game_id INTEGER);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
