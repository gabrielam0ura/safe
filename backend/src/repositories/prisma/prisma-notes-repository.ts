import { prisma } from '@/lib/prisma'
import type { Note, Prisma } from '@prisma/client'
import type { NotesRepository } from '../notes-repository'

import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'

dayjs.extend(utc)

export class PrismaNotesRepository implements NotesRepository {
  async create(data: Prisma.NoteUncheckedCreateInput){
      const note = await prisma.note.create({
        data: {
          ...data,
          createdAt: dayjs().utc().subtract(3, 'hour').toDate(),
          updatedAt: dayjs().utc().subtract(3, 'hour').toDate(),
        },
        
      })
      return note
  }

  async findById(id: string){
      const note = await prisma.note.findUnique({
        where: {
            id
        }
      })
      return note
  }

  async delete(id: string) {
      await prisma.note.delete({
        where:{
            id
        }
    })
  }
  
  async findManyByUserId(userId: string){
      const notes = await prisma.note.findMany({
        where: {
            userId
        },
        orderBy: {
          updatedAt: 'desc',
        }
      })
      return notes
  }

  async searchMany(query: string, userId: string) {
    const notes = prisma.note.findMany({
      where: {
        title: {
          contains: query,
        },
        userId,
      },
      orderBy: {
        updatedAt: 'desc',
      }
    })

    return notes
  }

  async searchManyByDate(startDate: Date, endDate: Date, userId: string){
    const notes = prisma.note.findMany({
        where: {
          createdAt: {
            gte: startDate,
            lte: endDate,
          },
          userId,
        },
        orderBy: {
          updatedAt: 'desc',
        }
      })
  
      return notes
  }


  async save(data: Note) {
    const note = await prisma.note.update({
      where: {
        id: data.id,
      },
      data: {
        title: data.title,
        content: data.content,
        updatedAt: dayjs().utc().subtract(3, 'hour').toDate(),
      },
    })

    return note
  }

}