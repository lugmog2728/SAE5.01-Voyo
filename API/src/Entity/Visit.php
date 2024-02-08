<?php

namespace App\Entity;

use App\Repository\VisitRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: VisitRepository::class)]
class Visit
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(type: Types::DATETIME_MUTABLE)]
    private ?\DateTimeInterface $dateVisit = null;

    #[ORM\Column(length: 64)]
    private ?string $statut = null;

    #[ORM\Column(length: 64)]
    private ?string $city = null;

    #[ORM\Column(length: 100)]
    private ?string $street = null;

    #[ORM\Column(length: 5)]
    private ?string $postalCode = null;

    #[ORM\Column(nullable: true)]
    private ?int $realDuration = null;

    #[ORM\ManyToOne(inversedBy: 'visits')]
    #[ORM\JoinColumn(nullable: false)]
    private ?housingType $housingType = null;

    #[ORM\ManyToOne(inversedBy: 'visits')]
    #[ORM\JoinColumn(nullable: false)]
    private ?visitor $visitor = null;

    #[ORM\ManyToOne(inversedBy: 'visits')]
    #[ORM\JoinColumn(nullable: false)]
    private ?User $userVisit = null;

    #[ORM\Column(nullable: true)]
    private ?int $rating = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $comment = null;

    #[ORM\OneToMany(mappedBy: 'visit', targetEntity: PointToCheck::class, orphanRemoval: true)]
    private Collection $pointToChecks;

    public function __construct()
    {
        $this->pointToChecks = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getDateVisit(): ?\DateTimeInterface
    {
        return $this->dateVisit;
    }

    public function setDateVisit(\DateTimeInterface $dateVisit): static
    {
        $this->dateVisit = $dateVisit;

        return $this;
    }

    public function getStatut(): ?string
    {
        return $this->statut;
    }

    public function setStatut(string $statut): static
    {
        $this->statut = $statut;

        return $this;
    }

    public function getCity(): ?string
    {
        return $this->city;
    }

    public function setCity(string $city): static
    {
        $this->city = $city;

        return $this;
    }

    public function getStreet(): ?string
    {
        return $this->street;
    }

    public function setStreet(string $street): static
    {
        $this->street = $street;

        return $this;
    }

    public function getPostalCode(): ?string
    {
        return $this->postalCode;
    }

    public function setPostalCode(string $postalCode): static
    {
        $this->postalCode = $postalCode;

        return $this;
    }

    public function getRealDuration(): ?int
    {
        return $this->realDuration;
    }

    public function setRealDuration(?int $realDuration): static
    {
        $this->realDuration = $realDuration;

        return $this;
    }

    public function getHousingType(): ?housingType
    {
        return $this->housingType;
    }

    public function setHousingType(?housingType $housingType): static
    {
        $this->housingType = $housingType;

        return $this;
    }

    public function getVisitor(): ?visitor
    {
        return $this->visitor;
    }

    public function setVisitor(?visitor $visitor): static
    {
        $this->visitor = $visitor;

        return $this;
    }

    public function getUserVisit(): ?User
    {
        return $this->userVisit;
    }

    public function setUserVisit(?User $userVisit): static
    {
        $this->userVisit = $userVisit;

        return $this;
    }

    public function getRating(): ?int
    {
        return $this->rating;
    }

    public function setRating(?int $rating): static
    {
        $this->rating = $rating;

        return $this;
    }

    public function getComment(): ?string
    {
        return $this->comment;
    }

    public function setComment(?string $comment): static
    {
        $this->comment = $comment;

        return $this;
    }

    /**
     * @return Collection<int, PointToCheck>
     */
    public function getPointToChecks(): Collection
    {
        return $this->pointToChecks;
    }

    public function addPointToCheck(PointToCheck $pointToCheck): static
    {
        if (!$this->pointToChecks->contains($pointToCheck)) {
            $this->pointToChecks->add($pointToCheck);
            $pointToCheck->setVisit($this);
        }

        return $this;
    }

    public function removePointToCheck(PointToCheck $pointToCheck): static
    {
        if ($this->pointToChecks->removeElement($pointToCheck)) {
            // set the owning side to null (unless already changed)
            if ($pointToCheck->getVisit() === $this) {
                $pointToCheck->setVisit(null);
            }
        }

        return $this;
    }
}
