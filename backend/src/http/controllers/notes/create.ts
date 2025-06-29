import { makeCreateNoteUseCase } from '@/use-cases/factories/make-create-note-use-case'
import { prisma } from '@/lib/prisma'
import type { FastifyReply, FastifyRequest } from 'fastify'
import { z } from 'zod'

export async function create(request: FastifyRequest, reply: FastifyReply) {
  const createNoteBodySchema = z.object({
    title: z.string().min(3, "O titulo deve ter no minimo 3 caracteres").max(30, "O titulo deve ter no maximo 30 caracteres"),
    content: z.string().min(25, "O conteúdo deve ter no minimo 25 caracteres").max(300, "O conteúdo deve ter no maximo 300 caracteres"),
  })

  const { title, content } =
  createNoteBodySchema.parse(request.body)

  const defaultUser = await prisma.user.findUnique({
    where: {
      email: 'default@example.com'
    }
  })

  if (!defaultUser) {
    return reply.status(500).send({ error: 'Usuário padrão não encontrado. Execute o seed primeiro.' })
  }

  const createNoteUseCase = makeCreateNoteUseCase()

  await createNoteUseCase.execute({
    title,
    content,
    userId: defaultUser.id,
  })

  return reply.status(201).send()
}