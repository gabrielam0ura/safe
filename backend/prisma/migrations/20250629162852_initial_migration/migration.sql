/*
  Warnings:

  - Made the column `updatedAt` on table `notes` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "notes" ALTER COLUMN "updatedAt" SET NOT NULL;
