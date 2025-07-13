import { prisma } from '@/lib/prisma'
import type { Prisma } from '@prisma/client'
import type { UsersRepository } from '../users-repository'

import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'

dayjs.extend(utc)

export class PrismaUsersRepository implements UsersRepository {
  async findById(id: string) {
    const user = await prisma.user.findUnique({
      where: {
        id,
      },
    })

    return user
  }
  async findByEmail(email: string) {
    const user = await prisma.user.findUnique({
      where: {
        email,
      },
    })

    return user
  }
  async create(data: Prisma.UserCreateInput) {
    const user = await prisma.user.create({
      data: {
        ...data,
        created_at: dayjs().utc().subtract(3, 'hour').toDate(),
      },
    })

    return user
  }
}