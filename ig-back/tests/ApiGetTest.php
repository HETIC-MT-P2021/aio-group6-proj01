<?php

namespace App\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class ApiGetTest extends WebTestCase {

    public function testGetCategories() {

        $client = static::createClient();
        $client->request('GET', '/api/categories');

        $this->assertEquals(200, $client->getResponse()->getStatusCode());
    }

    public function testGetImages() {

        $client = static::createClient();
        $client->request('GET', '/api/images');

        $this->assertEquals(200, $client->getResponse()->getStatusCode());
    }

    public function testGetTags() {

        $client = static::createClient();
        $client->request('GET', '/api/tags');

        $this->assertEquals(200, $client->getResponse()->getStatusCode());
    }
}