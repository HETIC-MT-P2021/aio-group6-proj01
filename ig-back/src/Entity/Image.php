<?php

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiResource;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Symfony\Component\Serializer\Annotation\MaxDepth;
use Symfony\Component\Serializer\Annotation\Groups;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ApiResource(attributes={
 *     "normalization_context": {"groups"={"read"},
 *     "denormalizationContext={"groups"={"write"},
 *     "enable_max_depth"=true}}
 *     )
 * @ORM\Entity(repositoryClass="App\Repository\ImageRepository")
 */
class Image
{
    /**
     * @ORM\Id()
     * @ORM\GeneratedValue()
     * @Groups({"read"})
     * @ORM\Column(type="integer")
     */
    private $id;

    /**
     * @ORM\ManyToOne(targetEntity="App\Entity\Category", inversedBy="images")
     * @ORM\JoinColumn(nullable=true)
     * @Groups({"read", "write"})
     * @MaxDepth(5)
     */
    private $category;

    /**
     * @ORM\ManyToMany(targetEntity="App\Entity\Tag", mappedBy="images")
     * @ORM\JoinColumn(nullable=true)
     * @Groups({"read", "write"})
     * @MaxDepth(5)
     */
    private $tags;

    /**
     * @ORM\Column(type="string", length=255)
     * @Groups({"read", "write"})
     * @MaxDepth(5)
     */
    private $path;

    /**
     * @ORM\Column(type="text", nullable=true)
     * @Groups({"read", "write"})
     * @MaxDepth(5)
     */
    private $description;

    /**
     * @ORM\Column(type="date", nullable=true)
     */
    private $addedAt;

    /**
     * @ORM\Column(type="date", nullable=true)
     */
    private $updatedAt;

    public function __construct()
    {
        $this->tags = new ArrayCollection();

        $this->setUpdatedAt(new \DateTime('now'));
        if ($this->getAddedAt() === null) {
            $this->setAddedAt(new \DateTime('now'));
        }
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getCategory(): ?Category
    {
        return $this->category;
    }

    public function setCategory(?Category $category): self
    {
        $this->category = $category;

        return $this;
    }

    /**
     * @return Collection|Tag[]
     */
    public function getTags(): Collection
    {
        return $this->tags;
    }

    public function addTag(Tag $tag): self
    {
        if (!$this->tags->contains($tag)) {
            $this->tags[] = $tag;
            $tag->addImage($this);
        }

        return $this;
    }

    public function removeTag(Tag $tag): self
    {
        if ($this->tags->contains($tag)) {
            $this->tags->removeElement($tag);
            $tag->removeImage($this);
        }

        return $this;
    }

    public function getPath(): ?string
    {
        return $this->path;
    }

    public function setPath(string $path): self
    {
        $this->path = $path;

        return $this;
    }

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(?string $description): self
    {
        $this->description = $description;

        return $this;
    }

    public function getAddedAt(): ?\DateTimeInterface
    {
        return $this->addedAt;
    }

    public function setAddedAt(\DateTimeInterface $addedAt): self
    {
        $this->addedAt = $addedAt;

        return $this;
    }

    public function getUpdatedAt(): ?\DateTimeInterface
    {
        return $this->updatedAt;
    }

    public function setUpdatedAt(?\DateTimeInterface $updatedAt): self
    {
        $this->updatedAt = $updatedAt;

        return $this;
    }
}
