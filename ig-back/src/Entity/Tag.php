<?php

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiResource;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Symfony\Component\Serializer\Annotation\Groups;
use Symfony\Component\Serializer\Annotation\MaxDepth;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ApiResource(attributes={
 *     "normalization_context"={"groups"={"read"}},
 *     "denormalizationContext"={"groups"={"write"}},
 *     "enable_max_depth"=true}
 *     )
 * @ORM\Entity(repositoryClass="App\Repository\TagRepository")
 */
class Tag
{
    /**
     * @ORM\Id()
     * @ORM\GeneratedValue()
     * @ORM\Column(type="integer")
     */
    private $id;

    /**
     * @ORM\ManyToMany(targetEntity="App\Entity\Image", inversedBy="tags")
     * @ORM\JoinColumn(nullable=true)
     * @Groups({"read", "write"})
     * @MaxDepth(5)
     */
    private $images;

    /**
     * @ORM\Column(type="string", length=100)
     * @Groups({"read", "write"})
     * @MaxDepth(5)
     */
    private $title;

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
        $this->images = new ArrayCollection();

        $this->setUpdatedAt(new \DateTime('now'));
        if ($this->getAddedAt() === null) {
            $this->setAddedAt(new \DateTime('now'));
        }
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    /**
     * @return Collection|Image[]
     */
    public function getImages(): Collection
    {
        return $this->images;
    }

    public function addImage(Image $image): self
    {
        if (!$this->images->contains($image)) {
            $this->images[] = $image;
        }

        return $this;
    }

    public function removeImage(Image $image): self
    {
        if ($this->images->contains($image)) {
            $this->images->removeElement($image);
        }

        return $this;
    }

    public function getTitle(): ?string
    {
        return $this->title;
    }

    public function setTitle(string $title): self
    {
        $this->title = $title;

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
