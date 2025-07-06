import { callDefaultUserId } from '@/lib/default-user'
import { makeSearchNotesByDateUseCase } from '@/use-cases/factories/make-search-notes-by-date-use-case'
import type { FastifyReply, FastifyRequest } from 'fastify'
import { z } from 'zod'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'

dayjs.extend(utc)

export async function searchByDate(
  request: FastifyRequest,
  reply: FastifyReply,
) {
  const notesDateQuerySchema = z.object({
    date: z.coerce.date().optional(),
    startDate: z.coerce.date().optional(),
    endDate: z.coerce.date().optional(),
  }).refine((data) => {
    return(data.date !== undefined) || (data.startDate !== undefined)
  }, {
    message: "Deve fornecer 'date' ou ambos 'startDate' e 'endDate'"
  })

  const { date, startDate, endDate } = notesDateQuerySchema.parse(
    request.query,
  )

  let finalStartDate: Date
  let finalEndDate: Date

  if(date) {
    finalStartDate = dayjs.utc(date).startOf('day').toDate()
    finalEndDate = dayjs.utc(date).endOf('day').toDate()

  } else {
    if (dayjs.utc(startDate!).isSame(dayjs.utc(endDate!), 'day')) {
        finalStartDate = dayjs.utc(startDate!).startOf('day').toDate()
        finalEndDate = dayjs.utc(startDate!).endOf('day').toDate()
      } else {
        finalStartDate = dayjs.utc(startDate!).toDate()
        finalEndDate = dayjs.utc(endDate!).toDate()
      }
  }

  const searchNotesByDateUseCase = makeSearchNotesByDateUseCase()

  const { notes } = await searchNotesByDateUseCase.execute({
    startDate: finalStartDate,
    endDate: finalEndDate,
    userId: await callDefaultUserId()
  })

  return reply.status(200).send({ notes })
}