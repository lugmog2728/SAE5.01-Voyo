<?php

namespace App\Repository;

use App\Entity\HousingType;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<HousingType>
 *
 * @method HousingType|null find($id, $lockMode = null, $lockVersion = null)
 * @method HousingType|null findOneBy(array $criteria, array $orderBy = null)
 * @method HousingType[]    findAll()
 * @method HousingType[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class HousingTypeRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, HousingType::class);
    }

//    /**
//     * @return HousingType[] Returns an array of HousingType objects
//     */
//    public function findByExampleField($value): array
//    {
//        return $this->createQueryBuilder('h')
//            ->andWhere('h.exampleField = :val')
//            ->setParameter('val', $value)
//            ->orderBy('h.id', 'ASC')
//            ->setMaxResults(10)
//            ->getQuery()
//            ->getResult()
//        ;
//    }

//    public function findOneBySomeField($value): ?HousingType
//    {
//        return $this->createQueryBuilder('h')
//            ->andWhere('h.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }
}
