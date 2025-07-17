import { PrismaClient } from '@prisma/client'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import { randomUUID } from 'crypto'

dayjs.extend(utc)
dayjs.extend(timezone)

const prisma = new PrismaClient()

async function main() {

  const user = await prisma.user.upsert({
    where: { email: 'default@example.com' },
    update: {},
    create: {
      name: 'SafeUser',
      email: 'safeuser@user.com',
      password_hash: "Saf3Password",
      created_at: dayjs().utc().subtract(3, 'hour').toDate()
    },
  })

  console.log('Usuário padrão criado:', user)

  const noteIds = [randomUUID(), randomUUID(), randomUUID(), randomUUID()]

  const notes = await Promise.all([
    prisma.note.upsert({
      where: { id: noteIds[0] },
      update: {},
      create: {
        id: noteIds[0],
        title: 'Anotação Importante',
        content: 'Esta é minha primeira anotação no app Safe.',
        createdAt: new Date('2025-07-13T10:00:00Z'),
        updatedAt: new Date('2025-07-13T10:00:00Z'),
        userId: user.id,
      },
    }),
    prisma.note.upsert({
      where: { id: noteIds[1] },
      update: {},
      create: {
        id: noteIds[1],
        title: 'Lista de Compras',
        content: 'Leite, pão, ovos, frutas e verduras.',
        createdAt: new Date('2025-07-15T14:30:00Z'),
        updatedAt: new Date('2025-07-15T14:30:00Z'),
        userId: user.id,
      },
    }),
    prisma.note.upsert({
      where: { id: noteIds[2] },
      update: {},
      create: {
        id: noteIds[2],
        title: '8 meses',
        content: 'Comemorar 8 meses de namoro (te amo milady).',
        createdAt: new Date('2025-07-16T09:15:00Z'),
        updatedAt: new Date('2025-07-16T09:15:00Z'),
        userId: user.id,
      },
    }),
    prisma.note.upsert({
      where: { id: noteIds[3] },
      update: {},
      create: {
        id: noteIds[3],
        title: 'Lembretes Importantes: Apresentação',
        content: 'Apresentação do projeto hoje as 10h.',
        createdAt: new Date('2025-07-17T08:35:00Z'),
        updatedAt: new Date('2025-07-17T08:35:00Z'),
        userId: user.id,
      },
    }),
  ])

  console.log('Anotações criadas:', notes.length)

}

main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  }) 