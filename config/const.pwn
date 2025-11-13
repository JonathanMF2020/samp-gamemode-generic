#define WHITE               "{FFFFFF}"
#define PRIMARY             "{8EE7FF}"

// Mysql Credentials

#define MYSQL_DEBUG true

#define MYSQL_HOST          "localhost"
#define MYSQL_USER          "root"
#define MYSQL_PASWORD       "root"
#define MYSQL_DATABASE      "samp"

#define SERVER_NAME         "Aknolwedge Roleplay"

#define TABLE_USERS         "users"


enum{
    DIALOG_REGISTER,
    DIALOG_LOGIN
}

new MySQL:database;
new stringScapeDatabase[256];