import { prisma } from "./prisma"

export async function callDefaultUserId(): Promise<string> {
    const defaultUser = await prisma.user.findUnique({
        where: {
          email: 'safeuser@user.com'
        }
      })
    
      if (!defaultUser) {
        throw new Error("Usuário padrão não encontrado. Execute o seed primeiro.")
      }

      return defaultUser.id
}