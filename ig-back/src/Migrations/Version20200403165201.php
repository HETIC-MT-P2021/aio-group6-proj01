<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20200403165201 extends AbstractMigration
{
    public function getDescription() : string
    {
        return '';
    }

    public function up(Schema $schema) : void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->abortIf($this->connection->getDatabasePlatform()->getName() !== 'mysql', 'Migration can only be executed safely on \'mysql\'.');

        $this->addSql('CREATE TABLE tag (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(100) NOT NULL, added_at DATE NOT NULL, updated_at DATE DEFAULT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE tag_image (tag_id INT NOT NULL, image_id INT NOT NULL, INDEX IDX_E7D11D59BAD26311 (tag_id), INDEX IDX_E7D11D593DA5256D (image_id), PRIMARY KEY(tag_id, image_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE image (id INT AUTO_INCREMENT NOT NULL, category_id INT NOT NULL, path VARCHAR(255) NOT NULL, description LONGTEXT DEFAULT NULL, added_at DATE NOT NULL, updated_at DATE DEFAULT NULL, INDEX IDX_C53D045F12469DE2 (category_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE category (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(100) NOT NULL, added_at DATE NOT NULL, updated_at DATE NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('ALTER TABLE tag_image ADD CONSTRAINT FK_E7D11D59BAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE tag_image ADD CONSTRAINT FK_E7D11D593DA5256D FOREIGN KEY (image_id) REFERENCES image (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE image ADD CONSTRAINT FK_C53D045F12469DE2 FOREIGN KEY (category_id) REFERENCES category (id)');
    }

    public function down(Schema $schema) : void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->abortIf($this->connection->getDatabasePlatform()->getName() !== 'mysql', 'Migration can only be executed safely on \'mysql\'.');

        $this->addSql('ALTER TABLE tag_image DROP FOREIGN KEY FK_E7D11D59BAD26311');
        $this->addSql('ALTER TABLE tag_image DROP FOREIGN KEY FK_E7D11D593DA5256D');
        $this->addSql('ALTER TABLE image DROP FOREIGN KEY FK_C53D045F12469DE2');
        $this->addSql('DROP TABLE tag');
        $this->addSql('DROP TABLE tag_image');
        $this->addSql('DROP TABLE image');
        $this->addSql('DROP TABLE category');
    }
}
