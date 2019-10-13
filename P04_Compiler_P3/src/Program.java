import com.sun.jdi.Value;
import de.inetsoftware.jwebassembly.JWebAssembly;
import de.inetsoftware.jwebassembly.module.*;

public class Program implements Emitter {

    static void program() throws Exception {
        statementSequence();
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.UNREACHABLE, 0));
    }

    static void statementSequence() throws Exception {
        do {
            statement();
        } while (Scanner.la != Token.EOF && Scanner.la != Token.RCBRACK);
    }

    static void statement() throws Exception {
        switch (Scanner.la) {
            case Token.IDENT:
                assignment();
                break;
            case Token.RETURN:
                returnStatement();
                break;
            case Token.IF:
                ifStatement();
                break;
            case Token.WHILE:
                whileStatement();
                break;
            case Token.LCBRACK:
                block();
                break;
            default:
                System.out.println("bla");
        }
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

    static void ifStatement() throws Exception {
        Scanner.check(Token.IF);
        condition();
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.IF, 0));

        statement();
        if (Scanner.la == Token.ELSE) {
            Scanner.check(Token.ELSE);
            JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.ELSE, 0));
            statement();
        }
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.END, 0));
    }

    static void condition() throws Exception {
        Scanner.check(Token.LBRACK);

        boolean isNot = false;
        if (Scanner.la == Token.NOT) {
            Scanner.check(Token.NOT);
            isNot = true;
        }
        Calculator.expr();
        JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.nearest, ValueType.f64, 0));
        JWebAssembly.il.add(new WasmConvertInstruction(ValueTypeConvertion.d2i, 0));

        if (isNot) {
            JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.eqz, ValueType.i32,0));
        } else {
            JWebAssembly.il.add(new WasmConstInstruction(0.0, 0));
            JWebAssembly.il.add(new WasmConvertInstruction(ValueTypeConvertion.d2i, 0));
            JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.ne, ValueType.i32, 0));
        }

        Scanner.check(Token.RBRACK);
    }

    static void block() throws Exception {
        Scanner.check(Token.LCBRACK);
        statementSequence();
        Scanner.check(Token.RCBRACK);
    }

    static void whileStatement() throws Exception {
        Scanner.check(Token.WHILE);
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.BLOCK, 0));
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.LOOP,0));
        condition();
        JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.eqz, ValueType.i32,0));
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.BR_IF, 1,0));
        statement();
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.BR,0,0));
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.END,0));
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.END,0));
    }

    public static void main(String[] args) throws Exception {
        String bspCode = "x = $arg0;" +
                "a = 1;" +
                "b = 2 + a;" +
                "c = 3 + b;" +
                "if (x) {c = 3;}" +
                "value = a*x*x + b*x + c;" +
                "return value;";
        String test1 = "m = $arg0 - 42;" +
                "if (m) {" +
                " a = 7.0 ;" +
                "} else {" +
                "a = 5 ;" +
                "}" +
                "m = m - a;" +
                "return m;";
        String test2 = "m = $arg0 - 42;" +
                "if (!m) {" +
                "return 7;" +
                "} else {" +
                "return 666;" +
                "}";
        String test3 = "m = $arg0;" +
                "s = 1;" +
                "while(m){" +
                "s = s + 1;" +
                "m = m-1;" +
                "}" +
                "return s;";
        String test4 = "m = $arg0;" +
                "s = 1;" +
                "while(m){" +
                "s = s * m;" +
                "m = m-1;" +
                "}" +
                "return s;";
        /*String bspCode = "m = $arg0 - 42;\n" +
                "if (!m) {\n" +
                "return 7;\n" +
                "} else {\n" +
                "return 666;\n" +
                "}";*/
        Scanner.init(test3);
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
