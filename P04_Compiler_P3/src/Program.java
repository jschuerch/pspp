import de.inetsoftware.jwebassembly.JWebAssembly;
import de.inetsoftware.jwebassembly.module.*;

public class Program implements Emitter {

    static void program() throws Exception {
        statementSequence();
        /*JWebAssembly.il.add(new WasmLoadStoreInstruction(true, JWebAssembly.local(ValueType.f64, "value"), 0));
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.RETURN, null, 0));*/
    }

    static void statementSequence() throws Exception {
        statement();
        do {
            statement();
        } while (Scanner.la != Token.EOF);
    }

    static void statement() throws Exception {
        if (Scanner.la == Token.IDENT)
            assignment();
        else if (Scanner.la == Token.RETURN)
            returnStatement();
    }

    static void assignment() throws Exception {
        Scanner.check(Token.IDENT);
        int slotNumber = JWebAssembly.local(ValueType.f64, Scanner.token.str);
        Scanner.check(Token.EQUAL);
        Calculator.expr();
        JWebAssembly.il.add(new WasmLoadStoreInstruction(false, slotNumber, 0));
        Scanner.check(Token.SCOLON);
    }

    static void returnStatement() throws Exception {
        Scanner.check(Token.RETURN);
        Calculator.expr();
        Scanner.check(Token.SCOLON);
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.RETURN, null, 0));
    }
/*
    static void ifStatement() throws Exception {
        Scanner.check(Token.IF);
        condition();
        // TODO Branch to places?
        statement();
        if (Scanner.la == Token.ELSE) {
            Scanner.scan();
            statement();
        }

    }

    static void condition() throws Exception {
        Scanner.check(Token.LBRACK);
        if (Scanner.la == Token.NOT) {
            // TODO not...
        }
        Calculator.expr();
        Scanner.check(Token.RBRACK);
    }

    static void whileStatement() throws Exception {
        Scanner.check(Token.WHILE);
        condition();
        statement();
    }

    static void block() throws Exception {
        Scanner.check(Token.LCBRACK);
        statementSequence();
        Scanner.check(Token.RCBRACK);
    }
*/
    public static void main(String[] args) throws Exception {
        String bspCode = "x = $arg0;" +
                "a = 5;" +
                "b = 2 + a;" +
                "c = 3 + b;" +
                "value = a*x*x + b*x + c;" +
                "return value;";
        Scanner.init(bspCode);
        Scanner.scan();
        JWebAssembly.emitCode(IProgram.class, new Program());
    }

    public interface IProgram {
        double main(double arg);
    }

    @Override
    public void emit() {
        try {
            program();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
