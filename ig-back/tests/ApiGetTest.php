<?php

namespace App\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class ApiGetTest extends WebTestCase {

    public function testGetCategories() {

        $client = static::createClient();
        $client->request('GET', '/api/categories');
        $response = $client->getResponse();
        $this->assertJsonResponse($response, 200);

        $content = json_decode($response->getContent(), true);
        $this->assertInternalType('array', $content);
        $this->assertCount(5, $content);

        $comment = $content[0];
        $this->assertArrayHasKey('body', $comment);
        $this->assertArrayHasKey('status', $comment);
        $this->assertArrayNotHasKey('content', $comment);
    }

    public function testGetImages() {

        $client = static::createClient();
        $client->request('GET', '/api/images');
        $response = $client->getResponse();
        $this->assertJsonResponse($response, 200);

        $content = json_decode($response->getContent(), true);
        $this->assertInternalType('array', $content);
        $this->assertCount(7, $content);

        $comment = $content[0];
        $this->assertArrayHasKey('body', $comment);
        $this->assertArrayHasKey('status', $comment);
        $this->assertArrayNotHasKey('content', $comment);
    }

    public function testGetTags() {

        $client = static::createClient();
        $client->request('GET', '/api/tags');
        $response = $client->getResponse();
        $this->assertJsonResponse($response, 200);

        $content = json_decode($response->getContent(), true);
        $this->assertInternalType('array', $content);
        $this->assertCount(5, $content);

        $comment = $content[0];
        $this->assertArrayHasKey('body', $comment);
        $this->assertArrayHasKey('status', $comment);
        $this->assertArrayNotHasKey('content', $comment);
    }
}