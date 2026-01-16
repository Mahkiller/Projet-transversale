import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/pages/loginAdmin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        // Default admin credentials for testing
        if(email != null && password != null) {
            // accept 'testadmin' or a few common variants
            if(("testadmin".equalsIgnoreCase(email) || "testadmin@gmail.com".equalsIgnoreCase(email) || "testadmin@admin.com".equalsIgnoreCase(email)) && "admin".equals(password)){
                HttpSession s = req.getSession(true);
                s.setAttribute("email", email);
                s.setAttribute("role", "admin");
                resp.sendRedirect(req.getContextPath() + "/addModele");
                return;
            }
        }
        req.setAttribute("error", "Identifiants invalides (admin)");
        req.getRequestDispatcher("/pages/loginAdmin.jsp").forward(req, resp);
    }
}
