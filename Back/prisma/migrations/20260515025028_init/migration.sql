/*
  Warnings:

  - The values [COMMENT] on the enum `ReportTargetType` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `commentCount` on the `Post` table. All the data in the column will be lost.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "ReportTargetType_new" AS ENUM ('POST', 'USER');
ALTER TABLE "public"."Report" ALTER COLUMN "targetType" DROP DEFAULT;
ALTER TABLE "Report" ALTER COLUMN "targetType" TYPE "ReportTargetType_new" USING ("targetType"::text::"ReportTargetType_new");
ALTER TYPE "ReportTargetType" RENAME TO "ReportTargetType_old";
ALTER TYPE "ReportTargetType_new" RENAME TO "ReportTargetType";
DROP TYPE "public"."ReportTargetType_old";
ALTER TABLE "Report" ALTER COLUMN "targetType" SET DEFAULT 'POST';
COMMIT;

-- AlterTable
ALTER TABLE "Post" DROP COLUMN "commentCount",
ADD COLUMN     "isDeleted" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "trendScore" DOUBLE PRECISION NOT NULL DEFAULT 0;

-- CreateIndex
CREATE INDEX "Post_trendScore_idx" ON "Post"("trendScore");
