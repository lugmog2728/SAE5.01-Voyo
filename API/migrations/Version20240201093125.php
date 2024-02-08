<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240201093125 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SEQUENCE availability_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE housing_type_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE point_to_check_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE user_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE visit_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE visitor_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE TABLE availability (id INT NOT NULL, visitor_id INT NOT NULL, day VARCHAR(15) NOT NULL, start_hour TIME(0) WITHOUT TIME ZONE NOT NULL, end_hour TIME(0) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_3FB7A2BF70BEE6D ON availability (visitor_id)');
        $this->addSql('CREATE TABLE housing_type (id INT NOT NULL, housing_type_libelle VARCHAR(64) NOT NULL, visit_duration INT NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE TABLE point_to_check (id INT NOT NULL, visit_id INT NOT NULL, wording VARCHAR(255) NOT NULL, comment VARCHAR(255) DEFAULT NULL, picture VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_A5D7C74175FA0FF2 ON point_to_check (visit_id)');
        $this->addSql('CREATE TABLE "user" (id INT NOT NULL, email VARCHAR(64) NOT NULL, password VARCHAR(64) NOT NULL, name VARCHAR(64) NOT NULL, first_name VARCHAR(64) NOT NULL, city VARCHAR(64) DEFAULT NULL, profil_picture VARCHAR(64) DEFAULT NULL, phone_number VARCHAR(10) DEFAULT NULL, active BOOLEAN NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE TABLE visit (id INT NOT NULL, housing_type_id INT NOT NULL, visitor_id INT NOT NULL, user_visit_id INT NOT NULL, date_visit TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, statut VARCHAR(64) NOT NULL, city VARCHAR(64) NOT NULL, street VARCHAR(100) NOT NULL, postal_code VARCHAR(5) NOT NULL, real_duration INT DEFAULT NULL, rating INT DEFAULT NULL, comment VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_437EE9397CB1EF5B ON visit (housing_type_id)');
        $this->addSql('CREATE INDEX IDX_437EE93970BEE6D ON visit (visitor_id)');
        $this->addSql('CREATE INDEX IDX_437EE9399577EBF2 ON visit (user_visit_id)');
        $this->addSql('CREATE TABLE visitor (id INT NOT NULL, identifiant_id INT NOT NULL, street VARCHAR(100) NOT NULL, hourly_rate DOUBLE PRECISION NOT NULL, postal_code VARCHAR(5) NOT NULL, rating INT NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_CAE5E19F1016936D ON visitor (identifiant_id)');
        $this->addSql('CREATE TABLE messenger_messages (id BIGSERIAL NOT NULL, body TEXT NOT NULL, headers TEXT NOT NULL, queue_name VARCHAR(190) NOT NULL, created_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, available_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, delivered_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_75EA56E0FB7336F0 ON messenger_messages (queue_name)');
        $this->addSql('CREATE INDEX IDX_75EA56E0E3BD61CE ON messenger_messages (available_at)');
        $this->addSql('CREATE INDEX IDX_75EA56E016BA31DB ON messenger_messages (delivered_at)');
        $this->addSql('COMMENT ON COLUMN messenger_messages.created_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('COMMENT ON COLUMN messenger_messages.available_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('COMMENT ON COLUMN messenger_messages.delivered_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('CREATE OR REPLACE FUNCTION notify_messenger_messages() RETURNS TRIGGER AS $$
            BEGIN
                PERFORM pg_notify(\'messenger_messages\', NEW.queue_name::text);
                RETURN NEW;
            END;
        $$ LANGUAGE plpgsql;');
        $this->addSql('DROP TRIGGER IF EXISTS notify_trigger ON messenger_messages;');
        $this->addSql('CREATE TRIGGER notify_trigger AFTER INSERT OR UPDATE ON messenger_messages FOR EACH ROW EXECUTE PROCEDURE notify_messenger_messages();');
        $this->addSql('ALTER TABLE availability ADD CONSTRAINT FK_3FB7A2BF70BEE6D FOREIGN KEY (visitor_id) REFERENCES visitor (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE point_to_check ADD CONSTRAINT FK_A5D7C74175FA0FF2 FOREIGN KEY (visit_id) REFERENCES visit (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE visit ADD CONSTRAINT FK_437EE9397CB1EF5B FOREIGN KEY (housing_type_id) REFERENCES housing_type (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE visit ADD CONSTRAINT FK_437EE93970BEE6D FOREIGN KEY (visitor_id) REFERENCES visitor (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE visit ADD CONSTRAINT FK_437EE9399577EBF2 FOREIGN KEY (user_visit_id) REFERENCES "user" (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE visitor ADD CONSTRAINT FK_CAE5E19F1016936D FOREIGN KEY (identifiant_id) REFERENCES "user" (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('DROP SEQUENCE availability_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE housing_type_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE point_to_check_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE user_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE visit_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE visitor_id_seq CASCADE');
        $this->addSql('ALTER TABLE availability DROP CONSTRAINT FK_3FB7A2BF70BEE6D');
        $this->addSql('ALTER TABLE point_to_check DROP CONSTRAINT FK_A5D7C74175FA0FF2');
        $this->addSql('ALTER TABLE visit DROP CONSTRAINT FK_437EE9397CB1EF5B');
        $this->addSql('ALTER TABLE visit DROP CONSTRAINT FK_437EE93970BEE6D');
        $this->addSql('ALTER TABLE visit DROP CONSTRAINT FK_437EE9399577EBF2');
        $this->addSql('ALTER TABLE visitor DROP CONSTRAINT FK_CAE5E19F1016936D');
        $this->addSql('DROP TABLE availability');
        $this->addSql('DROP TABLE housing_type');
        $this->addSql('DROP TABLE point_to_check');
        $this->addSql('DROP TABLE "user"');
        $this->addSql('DROP TABLE visit');
        $this->addSql('DROP TABLE visitor');
        $this->addSql('DROP TABLE messenger_messages');
    }
}
