import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // Create users
  const admin = await prisma.user.create({
    data: {
      email: 'admin@example.com',
      password: await bcrypt.hash('Admin@123', 10),
      role: 'ADMIN',
      name: 'Admin User',
    },
  });

  const coordinator = await prisma.user.create({
    data: {
      email: 'coordinator@example.com',
      password: await bcrypt.hash('Coord@123', 10),
      role: 'COORDINATOR',
      name: 'Coordinator User',
    },
  });

  const volunteer = await prisma.user.create({
    data: {
      email: 'volunteer@example.com',
      password: await bcrypt.hash('Vol@123', 10),
      role: 'VOLUNTEER',
      name: 'Volunteer User',
    },
  });

  console.log('✅ Users created:', { admin: admin.email, coordinator: coordinator.email, volunteer: volunteer.email });

  // Create location
  const location = await prisma.location.create({
    data: {
      latitude: 40.4168,
      longitude: -3.7038,
      address: 'Madrid, Spain',
      city: 'Madrid',
      country: 'Spain',
    },
  });

  console.log('✅ Location created:', location.city);

  // Create colony
  const colony = await prisma.colony.create({
    data: {
      name: 'Downtown Colony',
      locationId: location.id,
      ownerId: coordinator.id,
      description: 'Main urban colony',
      estimatedPopulation: 25,
      status: 'ACTIVE',
    },
  });

  console.log('✅ Colony created:', colony.name);

  // Create cats
  const cat1 = await prisma.cat.create({
    data: {
      colonyId: colony.id,
      name: 'Whiskers',
      color: 'Orange',
      gender: 'MALE',
      healthStatus: 'HEALTHY',
      sterilizationStatus: 'COMPLETED',
    },
  });

  const cat2 = await prisma.cat.create({
    data: {
      colonyId: colony.id,
      name: 'Luna',
      color: 'Black',
      gender: 'FEMALE',
      healthStatus: 'HEALTHY',
      sterilizationStatus: 'PENDING',
    },
  });

  console.log('✅ Cats created:', [cat1.name, cat2.name]);

  // Create sterilization record
  await prisma.sterilization.create({
    data: {
      catId: cat1.id,
      colonyId: colony.id,
      status: 'COMPLETED',
      completionDate: new Date(),
      recordedById: volunteer.id,
      veterinarian: 'Dr. Smith',
      clinicName: 'Pet Clinic',
    },
  });

  // Create health record
  await prisma.healthRecord.create({
    data: {
      catId: cat2.id,
      colonyId: colony.id,
      recordType: 'VACCINATION',
      description: 'Annual vaccination',
      recordedById: volunteer.id,
      veterinarian: 'Dr. Smith',
    },
  });

  console.log('✅ Sterilization and health records created');

  // Create collaborators
  await prisma.collaborator.create({
    data: {
      colonyId: colony.id,
      userId: volunteer.id,
      role: 'EDITOR',
      invitedBy: coordinator.id,
      status: 'ACCEPTED',
      acceptedAt: new Date(),
    },
  });

  console.log('✅ Collaborators created');

  console.log('🎉 Database seeded successfully!');
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
