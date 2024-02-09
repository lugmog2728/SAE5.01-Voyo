<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiResource;
use App\Repository\HousingTypeRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: HousingTypeRepository::class)]
#[ApiResource]
class HousingType
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 64)]
    private ?string $housingTypeLibelle = null;

    #[ORM\Column]
    private ?int $visitDuration = null;

    #[ORM\OneToMany(mappedBy: 'housingType', targetEntity: Visit::class)]
    private Collection $visits;

    public function __construct()
    {
        $this->visits = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getHousingTypeLibelle(): ?string
    {
        return $this->housingTypeLibelle;
    }

    public function setHousingTypeLibelle(string $housingTypeLibelle): static
    {
        $this->housingTypeLibelle = $housingTypeLibelle;

        return $this;
    }

    public function getVisitDuration(): ?int
    {
        return $this->visitDuration;
    }

    public function setVisitDuration(int $visitDuration): static
    {
        $this->visitDuration = $visitDuration;

        return $this;
    }

    /**
     * @return Collection<int, Visit>
     */
    public function getVisits(): Collection
    {
        return $this->visits;
    }

    public function addVisit(Visit $visit): static
    {
        if (!$this->visits->contains($visit)) {
            $this->visits->add($visit);
            $visit->setHousingType($this);
        }

        return $this;
    }

    public function removeVisit(Visit $visit): static
    {
        if ($this->visits->removeElement($visit)) {
            // set the owning side to null (unless already changed)
            if ($visit->getHousingType() === $this) {
                $visit->setHousingType(null);
            }
        }

        return $this;
    }
}
