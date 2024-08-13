-- Create the 'users' table
DROP table if exists "users";
CREATE TABLE "users" (
    "id" uuid NOT NULL DEFAULT gen_random_uuid(),
    "email" text NOT NULL,
    "password" text NOT NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    PRIMARY KEY ("id")
);

-- -- Create the 'visitors' table
DROP table if exists "visitors";

CREATE TABLE "visitors" (
    "id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"vid" text NOT NULL UNIQUE,
    "fname" text NOT NULL,
    "lname" text NOT NULL,
    "phone" text NOT NULL,
    "gender" text NOT NULL DEFAULT 'male',
    "department" text NOT NULL,
    "purpose" text NOT NULL DEFAULT 'appointment',
    "date" date NOT NULL,
    "time" time,
    "photo" text,
	"clocked_in_at" timestamptz,
	"clocked_out_at" timestamptz,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    PRIMARY KEY ("id")
);

-- Create a role 'anon' with no login capability
CREATE ROLE anon NOLOGIN;

-- -- Grant privileges to the 'anon' role
GRANT USAGE ON SCHEMA public TO anon;
GRANT SELECT ON "users" TO anon;
GRANT ALL PRIVILEGES ON "visitors" TO anon;
