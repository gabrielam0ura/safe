import { callDefaultUserId } from '@/lib/default-user'
import { makeFetchNotesUseCase } from '@/use-cases/factories/make-fetch-notes-use-case'
import type { FastifyReply, FastifyRequest } from 'fastify'

export async function list(request: FastifyRequest, reply: FastifyReply) {

  const fetchNotesUseCase = makeFetchNotesUseCase()

  const { notes } = await fetchNotesUseCase.execute({
    userId: await callDefaultUserId(),
  })

  return reply.status(200).send({
    notes,
  })
}