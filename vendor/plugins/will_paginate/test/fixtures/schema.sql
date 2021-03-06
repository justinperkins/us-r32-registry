CREATE TABLE 'replies' (
  'id' INTEGER PRIMARY KEY NOT NULL, 
  'content' text, 
  'created_at' datetime, 
  'updated_at' datetime, 
  'topic_id' integer
);

CREATE TABLE 'topics' (
  'id' INTEGER PRIMARY KEY NOT NULL, 
  'project_id' INTEGER DEFAULT NULL,
  'title' varchar(255), 
  'subtitle' varchar(255), 
  'content' text, 
  'created_at' datetime, 
  'updated_at' datetime
);

CREATE TABLE 'users' (
  'id' INTEGER PRIMARY KEY NOT NULL,
  'name' TEXT DEFAULT NULL,
  'salary' INTEGER DEFAULT 70000,
  'created_at' DATETIME DEFAULT NULL,
  'updated_at' DATETIME DEFAULT NULL,
  'type' TEXT DEFAULT NULL
);

CREATE TABLE 'projects' (
  'id' INTEGER PRIMARY KEY NOT NULL,
  'name' TEXT DEFAULT NULL
);

CREATE TABLE 'developers_projects' (
  'developer_id' INTEGER NOT NULL,
  'project_id' INTEGER NOT NULL,
  'joined_on' DATE DEFAULT NULL,
  'access_level' INTEGER DEFAULT 1
);
