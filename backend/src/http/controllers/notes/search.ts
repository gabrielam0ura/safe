import { callDefaultUserId } from '@/lib/default-user'
import { makeSearchNotesUseCase } from '@/use-cases/factories/make-search-notes-use-case'
import type { FastifyReply, FastifyRequest } from 'fastify'
import { z } from 'zod'

export async function search(
  request: FastifyRequest,
  reply: FastifyReply,
) {
  const notesQuerySchema = z.object({
    query: z.string(),
  })

  const { query } = notesQuerySchema.parse(
    request.query,
  )
    const searchNotesUseCase = makeSearchNotesUseCase()

    const { notes } = await searchNotesUseCase.execute({
      query,
      userId: await callDefaultUserId()
    })

    return reply.status(200).send({ notes })
  
}