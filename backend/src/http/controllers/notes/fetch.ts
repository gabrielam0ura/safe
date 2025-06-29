import { prisma } from '@/lib/prisma'
import { makeFetchNotesUseCase } from '@/use-cases/factories/make-fetch-notes-use-case'
import type { FastifyReply, FastifyRequest } from 'fastify'

export async function list(request: FastifyRequest, reply: FastifyReply) {

    const defaultUser = await prisma.user.findUnique({
        where: {
          email: 'default@example.com'
        }
      })
    
      if (!defaultUser) {
        return reply.status(500).send({ error: 'Usuário padrão não encontrado. Execute o seed primeiro.' })
      }
    

  const fetchNotesUseCase = makeFetchNotesUseCase()

  const { notes } = await fetchNotesUseCase.execute({
    userId: defaultUser.id,
  })

  return reply.status(200).send({
    notes,
  })
}