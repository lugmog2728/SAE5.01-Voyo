<?php

namespace App\Repository;

use App\Entity\PointToCheck;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<PointToCheck>
 *
 * @method PointToCheck|null find($id, $lockMode = null, $lockVersion = null)
 * @method PointToCheck|null findOneBy(array $criteria, array $orderBy = null)
 * @method PointToCheck[]    findAll()
 * @method PointToCheck[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class PointToCheckRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, PointToCheck::class);
    }

//    /**
//     * @return PointToCheck[] Returns an array of PointToCheck objects
//     */
//    public function findByExampleField($value): array
//    {
//        return $this->createQueryBuilder('p')
//            ->andWhere('p.exampleField = :val')
//            ->setParameter('val', $value)
//            ->orderBy('p.id', 'ASC')
//            ->setMaxResults(10)
//            ->getQuery()
//            ->getResult()
//        ;
//    }

//    public function findOneBySomeField($value): ?PointToCheck
//    {
//        return $this->createQueryBuilder('p')
//            ->andWhere('p.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }
}
