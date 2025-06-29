import { PrismaClient } from '@prisma/client'
import { hash } from 'bcryptjs'

const prisma = new PrismaClient()

async function main() {

  const user = await prisma.user.upsert({
    where: { email: 'default@example.com' },
    update: {},
    create: {
      name: 'Safe User',
      email: 'default@example.com',
      password_hash: "hashedpassword",
    },
  })

  console.log('Usuário padrão criado:', user)
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